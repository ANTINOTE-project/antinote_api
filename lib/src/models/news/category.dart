import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';

final class const NewsCategory({
  required final String label,
  required final String id,
  required final bool isDefault,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    label: nav.get('L'),
    id: nav.get('N'),
    isDefault: nav.getB('estDefaut'),
  );

  Map<String, dynamic> asJson() => {
    'L': label,
    'N': id,
    'estDefaut': isDefault,
  };

  @override
  CacheType? get cacheType => .NEWS_CATEGORY;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
    yield isDefault.visualIdData();
  }
}
