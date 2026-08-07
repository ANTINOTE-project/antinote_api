import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/colors.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';

final class const FoodLabel({
  required final String id,
  required final int index,
  required final String name,
  required final int color,
}) with VisualIdMixin {
  factory FoodLabel.decode(Map<String, dynamic> nav) {
    return FoodLabel(
      id: nav.get('N'),
      index: nav.get('G'),
      name: nav.get('L'),
      color: nav.get<String>('couleur').asRGB(),
    );
  }

  @override
  CacheType? get cacheType => .FOOD_LABEL;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield index.byteVisualIdData();
    yield name.visualIdData();
    yield color.colorVisualIdData();
  }
}
