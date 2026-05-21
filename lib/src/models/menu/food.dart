import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

import 'food_allergen.dart';
import 'food_label.dart';

class Food with VisualIdMixin {
  final String name;
  final String id;
  final List<FoodLabel> foodLabels;
  final List<FoodAllergen> foodAllergens;

  const Food({
    required this.name,
    required this.id,
    required this.foodLabels,
    required this.foodAllergens,
  });

  factory Food.decode(MapJsonNavigator nav) {
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
