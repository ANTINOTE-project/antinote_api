import 'dart:typed_data';

import 'package:antinote/antinote.dart';
import 'package:antinote/src/models/break.dart';

final class const Timetable({
  required final Map<String, dynamic>? absences,
  required final List<Break> breaks,

  required final bool withCanceledClasses,
  required final List<Class> classes,

  required final int? firstSlotForDay,
  required final int? middayMealStartSlot,
  required final int? middayMealEndSlot,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav, RemoteSession session) => .new(
    absences: nav.get('absences'),
    withCanceledClasses: nav.getB('avecCoursAnnule'),
    classes:
        (nav
                  .mGetLM('ListeCours')
                  ?.indexed
                  .map((e) => Class.decode(session, e.$2, e.$1))
                  .toList(growable: false) ??
              [])
          ..sort(
            (a, b) => a.startDate.millisecondsSinceEpoch.compareTo(
              b.startDate.millisecondsSinceEpoch,
            ),
          ),
    firstSlotForDay: nav.get('premierePlaceHebdoDuJour'),
    middayMealStartSlot: nav.get('debutDemiPensionHebdo'),
    middayMealEndSlot: nav.get('finDemiPensionHebdo'),
    breaks: nav.mGetLM('recreations')?.mapL((e) => .decode(e)) ?? [],
  );

  Set<DateTime> dayList() {
    final Set<DateTime> tr = {};

    for (final clazz in classes) {
      tr.add(clazz.startDate.toDay());
    }

    return tr;
  }

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* classes.visualIdForEach();
    yield* breaks.visualIdForEach();
  }

  @override
  List<VisualNavigator> get toStore => [
    for (final clazz in classes)
      .indexed(clazz, field: 'ListeCours', index: clazz.index),
  ];
}
