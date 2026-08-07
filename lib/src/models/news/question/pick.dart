import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';

final class const NewsQuestionPick({
  required final String label,
  required final String id,
  required final int rank,
  required final bool isFreeResponse,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    label: nav.get('L'),
    id: nav.get('N'),
    rank: nav.get('rang'),
    isFreeResponse: nav.get('estReponseLibre') ?? false,
  );

  @override
  CacheType? get cacheType => .NEWS_QUESTION_PICK;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
    yield rank.byteVisualIdData();
    yield isFreeResponse.visualIdData();
  }
}
