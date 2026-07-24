import 'package:antinote/src/helpers/datetime.dart';
import 'package:antinote/src/models/break.dart';
import 'package:antinote/src/models/classes/classes.dart';

final class const Timetable({
  required final Map<String, dynamic>? absences,
  required final List<Break> breaks,

  required final bool withCanceledClasses,
  required final List<Class> classes,

  required final int? firstSlotForDay,
  required final int? middayMealStartSlot,
  required final int? middayMealEndSlot,
}) {
  Set<DateTime> dayList() {
    final Set<DateTime> tr = {};

    for (final clazz in classes) {
      tr.add(clazz.startDate.toDay());
    }

    return tr;
  }
}
