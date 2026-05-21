import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

final class NewsCategory with VisualIdMixin {
  final String label;
  final String id;
  final bool? isDefault;

  const NewsCategory({
    required this.label,
    required this.id,
    required this.isDefault,
  });

  @override
  CacheType? get cacheType => .NEWS_CATEGORY;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
    yield isDefault?.visualIdData();
  }
}

extension AsNewsCategory on MapJsonNavigator {
  NewsCategory asNewsCategory() {
    return NewsCategory(
      label: get('L'),
      id: get('N'),
      isDefault: get('estDefault'),
    );
  }
}
