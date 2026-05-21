import 'dart:typed_data';

import 'package:antinote/src/helpers/colors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

class FoodLabel with VisualIdMixin {
  final String id;
  final int index;
  final String name;
  final int color;

  const FoodLabel({
    required this.id,
    required this.index,
    required this.name,
    required this.color,
  });

  factory FoodLabel.decode(MapJsonNavigator nav) {
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
