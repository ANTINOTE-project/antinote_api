import 'package:antinote/src/helpers/datetime.dart';
import 'package:antinote/src/models/break.dart';
import 'package:antinote/src/models/classes/classes.dart';

final class Timetable {
  final Map<String, dynamic>? absences;
  final List<Break> breaks;

  final bool withCanceledClasses;
  final List<Class> classes;

  final int? firstSlotForDay;
  final int? middayMealStartSlot;
  final int? middayMealEndSlot;

  Set<DateTime> dayList() {
    final Set<DateTime> tr = {};

    for (final clazz in classes) {
      tr.add(clazz.startDate.toDay());
    }

    return tr;
  }

  const Timetable({
    required this.absences,
    required this.breaks,
    required this.withCanceledClasses,
    required this.classes,
    required this.firstSlotForDay,
    required this.middayMealStartSlot,
    required this.middayMealEndSlot,
  });
}
