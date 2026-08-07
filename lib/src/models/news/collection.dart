import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/enum_id.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';
import 'package:antinote_api/src/models/news/display_mode.dart';
import 'package:antinote_api/src/models/news/news.dart';

final class const NewsCollection({
  required final List<News> news,
  required final NewsDisplayMode mode,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    news: nav.getLM('listeActualites').mapL((e) => .decode(e)),
    mode: NewsDisplayMode.values.byId(nav.get('G')),
  );

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* news.visualIdForEach();
  }

  @override
  List<VisualNavigator> get toStore => [
    for (final (index, newsPiece) in news.indexed)
      .indexed(newsPiece, field: 'listeActualites', index: index),
  ];
}
