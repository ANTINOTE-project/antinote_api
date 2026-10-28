import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/session.dart';
import 'package:antinote_api/src/models/break.dart';
import 'package:antinote_api/src/models/classes/classes.dart';
import 'package:antinote_api/src/models/period.dart';
import 'package:antinote_api/src/models/timetable.dart';
import 'package:antinote_api/src/models/week_frequency.dart';

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

final class const RecurringClass<T extends Class>({
  /// All the week numbers the class happens on.
  required final Set<int> weeks,

  /// Every occurrence if the class.
  required final List<RecurringClassInstance<T>> occurrences,

  /// This is to mark classes that only happen on select frequencies (ie. on
  /// even weeks)
  required final List<WeekFrequency> detectedCoveredFrequencies,

  /// This is not null when we can find a set of periods that perfectly match
  /// the first and last occurrences of the recurring class and covers every
  /// single instances.
  required final List<Period> detectedCoveredPeriods,

  /// The class that should be used to visually display the recurrence.
  required final T mockClass,

  /// Those happen when the specific occurrences do not visually match the mock
  /// class, this is when a class is cancelled, changes properties, etc...
  required final Map<int, T> exceptions,

  /// The visual IDs for each of the occurrences of the class. Useful when
  /// updating visuals of the recurring class.
  required final Set<String> visualIds,

  /// This is not null when all the [detectedCoveredFrequencies] follow
  /// themselves. In this case we say that the event happens every week (even if
  /// there aren't any lessons during holidays).
  required final Duration? calendarPeriodicity,

  /// This will automatically be empty if [calendarPeriodicity] is null.
  ///
  /// If the class does not happen on certain dates even though we define a
  /// [calendarPeriodicity], we provide the exceptions here which would be
  /// analogous to `EXDATE` in iCal.
  required final List<DateTime> calendarExceptions,
}) {
  factory decode(RemoteSession session, List<T> classes) {
    Map<String, List<T>> classMap = {};
    for (final (visualId, clazz) in classes.map((e) => (e.visualId, e))) {
      if (classMap.containsKey(visualId)) {
        classMap[visualId]!.add(clazz);
      } else {
        classMap[visualId] = [clazz];
      }
    }

    final occurrenceGroups = classMap.values.toList(growable: false);
    occurrenceGroups.sort((a, b) => -a.length.compareTo(b.length));

    final mockClass = occurrenceGroups.first.first;
    final Map<int, T> exceptions = Map.fromEntries(
      occurrenceGroups
          .sublist(1)
          .fold(
            <T>[],
            (previousValue, element) => previousValue..addAll(element),
          )
          .map((e) => MapEntry(e.weekNumber, e)),
    );

    final occurrences = classes.mapL(
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
      visualIds: classMap.keys.toSet(),
      calendarPeriodicity: periodicity,
      calendarExceptions: calendarExceptions,
    );
  }

  bool isClassType<C extends Class>() => T is C;

  bool isSameClassTypeAs(Class clazz) => clazz is T;
}

final class const RecurringTimetable({
  required final Map<String, dynamic>? absences,
  required final List<Break> breaks,

  required final bool withCanceledClasses,
  required final List<RecurringClass>? recurringClasses,

  required final int? firstSlotForDay,
  required final int? middayMealStartSlot,
  required final int? middayMealEndSlot,
}) {
  factory decode(RemoteSession session, Timetable table) {
    final Map<String, List<Class>> classes = {};

    for (final clazz in table.classes) {
      if (classes.containsKey(clazz.id)) {
        classes[clazz.id]!.add(clazz);
      } else {
        classes[clazz.id] = [clazz];
      }
    }

    return RecurringTimetable(
      absences: table.absences,
      breaks: table.breaks,
      withCanceledClasses: table.withCanceledClasses,
      recurringClasses: classes.values
          .map((e) => RecurringClass.decode(session, e))
          .toList(growable: false),
      firstSlotForDay: table.firstSlotForDay,
      middayMealStartSlot: table.middayMealStartSlot,
      middayMealEndSlot: table.middayMealEndSlot,
    );
  }
}
