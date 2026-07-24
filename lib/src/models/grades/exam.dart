import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/grades/grade.dart';
import 'package:antinote/src/models/period.dart';
import 'package:antinote/src/models/subject/service.dart';
import 'package:antinote/src/models/theme.dart';

final class const Exam({
  required final String id,
  required final int type,
  required final Grade selfGrade,
  required final Grade theoreticalMaxGrade,
  required final Grade defaultMaxGrade,
  required final DateTime date,
  required final Service service,
  required final Period period,
  required final List<Theme> themes,
  required final Grade? classAverage,
  required final bool? isInGroups,
  required final Grade? maxGrade,
  required final Grade? minGrade,
  required final String? comment,
  required final double? coefficient,
  required final bool? isOptional,
  required final bool? isBonus,
  required final bool? isCountedAs20TheoreticalMaxGrade,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    type: nav.get('G'),
    selfGrade: nav.get('note'),
    theoreticalMaxGrade: nav.get('bareme'),
    defaultMaxGrade: nav.get('baremeParDefaut'),
    date: nav.get('date'),
    service: .decode(nav.getM('service')),
    period: .decode(nav.getM('periode')),
    themes: nav.getLM('ListeThemes').mapL((e) => .decode(e)),
    classAverage: nav.get('moyenne'),
    isInGroups: nav.getB('estEnGroupe'),
    maxGrade: nav.get('noteMax'),
    minGrade: nav.get('noteMin'),
    comment: nav.get('commentaire'),
    coefficient: nav.get('coefficient'),
    isOptional: nav.getB('estFacultatif'),
    isBonus: nav.getB('estBonus'),
    isCountedAs20TheoreticalMaxGrade: nav.getB('estRamenerSur20'),
  );

  @override
  CacheType? get cacheType => .EXAM;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield type.byteVisualIdData();
    yield selfGrade.visualIdData();
    yield theoreticalMaxGrade.visualIdData();
    yield defaultMaxGrade.visualIdData();
    yield date.millisecondsSinceEpoch.bytesVisualIdData();
    yield* service.collectVisualIdData();
    yield* period.collectVisualIdData();
    yield* themes
        .mapL((e) => e.collectVisualIdData())
        .fold([], (previousValue, element) => [...previousValue, ...element]);
    yield classAverage?.visualIdData();
    yield isInGroups?.visualIdData();
    yield maxGrade?.visualIdData();
    yield minGrade?.visualIdData();
    yield comment?.visualIdData();
    yield coefficient?.visualIdData();
    yield isOptional?.visualIdData();
    yield isBonus?.visualIdData();
    yield isCountedAs20TheoreticalMaxGrade?.visualIdData();
  }
}
