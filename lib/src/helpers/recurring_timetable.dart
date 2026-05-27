import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/models/break.dart';
import 'package:antinote/src/models/classes/classes.dart';
import 'package:antinote/src/models/period.dart';
import 'package:antinote/src/models/timetable.dart';
import 'package:antinote/src/models/week_frequency.dart';

final class RecurringClassInstance<T extends Class> {
  final T mockValue;
  final int weekNumber;
  final bool isException;
  final DateTime startTime;
  final DateTime endTime;

  Duration get length => endTime.difference(startTime);

  const RecurringClassInstance({
    required this.mockValue,
    required this.weekNumber,
    required this.isException,
    required this.startTime,
    required this.endTime,
  });
}

final class RecurringClass<T extends Class> {
  bool isClassType<C extends Class>() => T is C;

  bool isSameClassTypeAs(Class clazz) => clazz is T;

  /// All the week numbers the class happens on.
  final Set<int> weeks;

  /// Every occurrence if the class.
  final List<RecurringClassInstance<T>> occurrences;

  /// This is to mark classes that only happen on select frequencies (ie. on
  /// even weeks)
  final List<WeekFrequency> detectedCoveredFrequencies;

  /// This is not null when we can find a set of periods that perfectly match
  /// the first and last occurrences of the recurring class and covers every
  /// single instances.
  final List<Period> detectedCoveredPeriods;

  /// The class that should be used to visually display the recurrence.
  final T mockClass;

  /// Those happen when the specific occurrences do not visually match the mock
  /// class, this is when a class is cancelled, changes properties, etc...
  final Map<int, T> exceptions;

  /// The visual IDs for each of the occurrences of the class. Useful when
  /// updating visuals of the recurring class.
  final Set<String> visualIds;

  /// This is not null when all the [detectedCoveredFrequencies] follow
  /// themselves. In this case we say that the event happens every week (even if
  /// there aren't any lessons during holidays).
  final Duration? calendarPeriodicity;

  /// This will automatically be empty if [calendarPeriodicity] is null.
  ///
  /// If the class does not happen on certain dates even though we define a
  /// [calendarPeriodicity], we provide the exceptions here which would be
  /// analogous to `EXDATE` in iCal.
  final List<DateTime> calendarExceptions;

  const RecurringClass({
    required this.weeks,
    required this.occurrences,
    required this.detectedCoveredFrequencies,
    required this.detectedCoveredPeriods,
    required this.mockClass,
    required this.exceptions,
    required this.visualIds,
    required this.calendarPeriodicity,
    required this.calendarExceptions,
  });
}

extension AsRecurringClass on List<Class> {
  RecurringClass asRecurringClass(PronoteSession session) {
    Map<String, List<Class>> classes = {};
    for (final (visualId, clazz) in map((e) => (e.visualId, e))) {
      if (classes.containsKey(visualId)) {
        classes[visualId]!.add(clazz);
      } else {
        classes[visualId] = [clazz];
      }
    }

    final occurrenceGroups = classes.values.toList(growable: false);
    occurrenceGroups.sort((a, b) => -a.length.compareTo(b.length));

    final mockClass = occurrenceGroups.first.first;
    final Map<int, Class> exceptions = Map.fromEntries(
      occurrenceGroups
          .sublist(1)
          .fold(
            <Class>[],
            (previousValue, element) => previousValue..addAll(element),
          )
          .map((e) => MapEntry(e.weekNumber, e)),
    );

    final occurrences = mapL(
      (e) => RecurringClassInstance(
        mockValue: exceptions[e.weekNumber] ?? mockClass,
        weekNumber: e.weekNumber,
        isException: exceptions.containsKey(e.weekNumber),
        startTime: e.startDate,
        endTime: e.endDate,
      ),
    );
    occurrences.sort((a, b) => a.weekNumber.compareTo(b.weekNumber));

    bool isPerWeek = false;
    Map<WeekFrequency, bool> metFrequencies = {};
    for (final MapEntry(key: weekNumber, value: frequency)
        in session.instance.weekFrequencies.entries.where(
          (element) =>
              element.key >= occurrences.first.weekNumber &&
              element.key <= occurrences.last.weekNumber,
        )) {
      final theoreticalStartTime = occurrences.first.startTime.add(
        Duration(days: 7 * (weekNumber - occurrences.first.weekNumber)),
      );
      if (session.instance.holidays.any(
        (element) => element.contains(theoreticalStartTime),
      )) {
        continue;
      }

      final occurrence = occurrences
          .where((element) => element.weekNumber == weekNumber)
          .singleOrNull;
      if (occurrence != null) {
        if (!metFrequencies.containsKey(frequency)) {
          metFrequencies[frequency] = true;
        } else if (metFrequencies[frequency] == false) {
          isPerWeek = true;
          break;
        }
      } else {
        metFrequencies[frequency] = false;
      }
    }

    final detectedFrequencies = isPerWeek
        ? <WeekFrequency>[]
        : metFrequencies.entries
              .where((element) => element.value)
              .map((e) => e.key)
              .toList(growable: false);

    final int? weekPeriodicity = isPerWeek
        ? 1
        : (detectedFrequencies.every(
                (element) => detectedFrequencies.contains(
                  session.instance.followingFrequencies[element],
                ),
              )
              ? 1
              : (detectedFrequencies.length == 1
                    ? session
                          .instance
                          .weekFrequenciesPeriodicity[detectedFrequencies
                          .single]
                    : null));
    final periodicity = weekPeriodicity != null
        ? Duration(days: weekPeriodicity * 7)
        : null;

    final List<DateTime> calendarExceptions = [];
    if (periodicity != null) {
      for (
        DateTime event = occurrences.first.startTime;
        event.isBefore(occurrences.last.startTime);
        event = event.add(periodicity)
      ) {
        if (!occurrences.any(
          (element) => element.startTime.isAtSameMomentAs(event),
        )) {
          calendarExceptions.add(event);
        }
      }
    }

    assert(
      occurrences.every(
        (occurrence) =>
            !(session.instance.holidays.any(
                  (holiday) => holiday.contains(occurrence.startTime),
                ) &&
                !calendarExceptions.contains(occurrence.startTime)),
      ),
    );

    return RecurringClass(
      weeks: occurrences.map((e) => e.weekNumber).toSet(),
      occurrences: occurrences,
      detectedCoveredFrequencies: detectedFrequencies,
      // TODO: Find for periods.
      detectedCoveredPeriods: [],
      mockClass: mockClass,
      exceptions: exceptions,
      visualIds: classes.keys.toSet(),
      calendarPeriodicity: periodicity,
      calendarExceptions: calendarExceptions,
    );
  }
}

final class RecurringTimetable {
  final Map<String, dynamic>? absences;
  final List<Break> breaks;

  final bool withCanceledClasses;
  final List<RecurringClass>? recurringClasses;

  final int? firstSlotForDay;
  final int? middayMealStartSlot;
  final int? middayMealEndSlot;

  const RecurringTimetable({
    required this.absences,
    required this.breaks,
    required this.withCanceledClasses,
    required this.recurringClasses,
    required this.firstSlotForDay,
    required this.middayMealStartSlot,
    required this.middayMealEndSlot,
  });
}

extension AsRecurringTimetable on Timetable {
  RecurringTimetable asRecurringTimetable(PronoteSession session) {
    final Map<String, List<Class>> classes = {};

    for (final clazz in this.classes) {
      if (classes.containsKey(clazz.id)) {
        classes[clazz.id]!.add(clazz);
      } else {
        classes[clazz.id] = [clazz];
      }
    }

    return RecurringTimetable(
      absences: absences,
      breaks: breaks,
      withCanceledClasses: withCanceledClasses,
      recurringClasses: classes.values
          .map((e) => e.asRecurringClass(session))
          .toList(growable: false),
      firstSlotForDay: firstSlotForDay,
      middayMealStartSlot: middayMealStartSlot,
      middayMealEndSlot: middayMealEndSlot,
    );
  }
}
