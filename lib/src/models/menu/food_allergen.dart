import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/colors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';

final class const FoodAllergen({
  required final int type,
  required final int place,
  required final String name,
  required final int color,
}) with VisualIdMixin {
  factory FoodAllergen.decode(MapJsonNavigator nav) {
    return FoodAllergen(
      type: nav.get('G'),
      place: nav.get('P'),
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
