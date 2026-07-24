import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';

final class const MCQ({
  required final String label,
  required final String id,
  required final int type,
  required final int totalQuestionCount,
  required final int totalPointsCount,
  required final bool withSubmittedQuestions,
  required final int requiredQuestionCount,
  required final int skillCount,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    label: nav.get('L'),
    id: nav.get('N'),
    type: nav.get('G'),
    totalQuestionCount: nav.get('nbQuestionsTotal'),
    totalPointsCount: nav.get('nombreDePointsTotal'),
    withSubmittedQuestions: nav.get('avecQuestionsSoumises'),
    requiredQuestionCount: nav.get('nombreQuestObligatoires'),
    skillCount: nav.get('nbCompetencesTotal'),
  );

  @override
  CacheType? get cacheType => .MCQ;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
    yield type.byteVisualIdData();
    yield totalQuestionCount.byteVisualIdData();
    yield totalPointsCount.bytesVisualIdData();
    yield withSubmittedQuestions.visualIdData();
    yield requiredQuestionCount.byteVisualIdData();
    yield skillCount.byteVisualIdData();
  }
}
