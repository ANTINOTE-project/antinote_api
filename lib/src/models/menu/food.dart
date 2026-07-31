import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';

import 'food_allergen.dart';
import 'food_label.dart';

final class const Food({
  required final String name,
  required final String id,
  required final List<FoodLabel> foodLabels,
  required final List<FoodAllergen> foodAllergens,
}) with VisualIdMixin {
  factory Food.decode(Map<String, dynamic> nav) {
    return Food(
      name: nav.get('L'),
      id: nav.get('N'),
      foodLabels: nav.getLM('listeLabelsAlimentaires').mapL(FoodLabel.decode),
      foodAllergens: nav
          .getLM('listeAllergenesAlimentaire')
          .mapL(FoodAllergen.decode),
    );
  }

  @override
  CacheType? get cacheType => .FOOD;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name.visualIdData();
    yield* foodLabels
        .map((e) => e.collectVisualIdData())
        .fold([], (previousValue, element) => [...previousValue, ...element]);
    yield* foodAllergens
        .map((e) => e.collectVisualIdData())
        .fold([], (previousValue, element) => [...previousValue, ...element]);
  }

  @override
  List<VisualIdMixin> get toStore => [...foodLabels, ...foodAllergens];
}
