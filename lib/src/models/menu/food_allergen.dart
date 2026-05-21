import 'dart:typed_data';

import 'package:antinote/src/helpers/colors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

class FoodAllergen with VisualIdMixin {
  final int indexG;
  final int indexP;
  final String name;
  final int color;

  const FoodAllergen({
    required this.indexG,
    required this.indexP,
    required this.name,
    required this.color,
  });

  factory FoodAllergen.decode(MapJsonNavigator nav) {
    return FoodAllergen(
      indexG: nav.get('G'),
      indexP: nav.get('P'),
      name: nav.get('L'),
      color: nav.get<String>('couleur').asRGB(),
    );
  }

  @override
  CacheType? get cacheType => .FOOD_ALLERGEN;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name.visualIdData();
    yield color.colorVisualIdData();
  }
}
