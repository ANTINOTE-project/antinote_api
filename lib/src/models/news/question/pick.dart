import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

final class NewsQuestionPick with VisualIdMixin {
  final String label;
  final String id;
  final int rank;
  final bool isFreeResponse;

  const NewsQuestionPick({
    required this.label,
    required this.id,
    required this.rank,
    required this.isFreeResponse,
  });

  @override
  CacheType? get cacheType => .NEWS_QUESTION_PICK;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
    yield rank.byteVisualIdData();
    yield isFreeResponse.visualIdData();
  }
}

extension AsNewsQuestionPick on MapJsonNavigator {
  NewsQuestionPick asNewsQuestionPick() {
    return NewsQuestionPick(
      label: get('L'),
      id: get('N'),
      rank: get('rang'),
      isFreeResponse: get('estReponseLibre') ?? false,
    );
  }
}
