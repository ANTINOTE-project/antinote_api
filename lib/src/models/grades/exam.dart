import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/grades/grade.dart';
import 'package:antinote/src/models/period.dart';
import 'package:antinote/src/models/subject/service.dart';
import 'package:antinote/src/models/theme.dart';

final class Exam with VisualIdMixin {
  final String id;
  final int type;
  final Grade selfGrade;
  final Grade theoreticalMaxGrade;
  final Grade defaultMaxGrade;
  final DateTime date;
  final Service service;
  final Period period;
  final List<Theme> themes;
  final Grade? classAverage;
  final bool? isInGroups;
  final Grade? maxGrade;
  final Grade? minGrade;
  final String? comment;
  final double? coefficient;
  final bool? isOptional;
  final bool? isBonus;
  final bool? isCountedAs20TheoreticalMaxGrade;

  const Exam({
    required this.id,
    required this.type,
    required this.selfGrade,
    required this.theoreticalMaxGrade,
    required this.defaultMaxGrade,
    required this.date,
    required this.service,
    required this.period,
    required this.themes,
    required this.classAverage,
    required this.isInGroups,
    required this.maxGrade,
    required this.minGrade,
    required this.comment,
    required this.coefficient,
    required this.isOptional,
    required this.isBonus,
    required this.isCountedAs20TheoreticalMaxGrade,
  });

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

extension AsExam on MapJsonNavigator {
  Exam asExam() {
    return Exam(
      id: get('N'),
      type: get('G'),
      selfGrade: get('note'),
      theoreticalMaxGrade: get('bareme'),
      defaultMaxGrade: get('baremeParDefaut'),
      date: get('date'),
      service: getM('service').asService(),
      period: getM('periode').asPeriod(),
      themes: getLM('ListeThemes').mapL((e) => e.asTheme()),
      classAverage: get('moyenne'),
      isInGroups: get('estEnGroupe'),
      maxGrade: get('noteMax'),
      minGrade: get('noteMin'),
      comment: get('commentaire'),
      coefficient: get('coefficient'),
      isOptional: get('estFacultatif'),
      isBonus: get('estBonus'),
      isCountedAs20TheoreticalMaxGrade: get('estRamenerSur20'),
    );
  }
}
