import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

final class MCQ with VisualIdMixin {
  final String label;
  final String id;
  final int type;
  final int totalQuestionCount;
  final int totalPointsCount;
  final bool withSubmittedQuestions;
  final int requiredQuestionCount;
  final int skillCount;

  const MCQ({
    required this.label,
    required this.id,
    required this.type,
    required this.totalQuestionCount,
    required this.totalPointsCount,
    required this.withSubmittedQuestions,
    required this.requiredQuestionCount,
    required this.skillCount,
  });

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

extension AsMCQ on MapJsonNavigator {
  MCQ asMCQ() {
    return MCQ(
      label: get('L'),
      id: get('N'),
      type: get('G'),
      totalQuestionCount: get('nbQuestionsTotal'),
      totalPointsCount: get('nombreDePointsTotal'),
      withSubmittedQuestions: get('avecQuestionsSoumises'),
      requiredQuestionCount: get('nombreQuestObligatoires'),
      skillCount: get('nbCompetencesTotal'),
    );
  }
}
