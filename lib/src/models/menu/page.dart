import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/menu/food_allergen.dart';
import 'package:antinote/src/models/menu/food_label.dart';
import 'package:antinote/src/models/menu/menu.dart';

final class MenuPage({
  required final bool withMiddayMeal,
  required final bool withEveningMeal,
  required final List<FoodAllergen> allergens,
  required final List<FoodLabel> labels,
  required final List<int> availableWeeks,
  required final List<Menu> menus,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    withMiddayMeal: nav.get('AvecRepasMidi'),
    withEveningMeal: nav.get('AvecRepasSoir'),
    allergens: nav.getLM('ListeAllergenes').mapL((e) => .decode(e)),
    labels: nav.getLM('Listelabels').mapL((e) => .decode(e)),
    availableWeeks: nav.get('DomaineDePresence'),
    menus: nav.getLM('ListeJours').mapL((e) => .decode(e)),
  );

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* menus.visualIdForEach();
  }

  @override
  List<VisualNavigator> get toStore => [
    for (final (index, menu) in menus.indexed)
      .new(exchanger: (nav) => nav.getLM('ListeJours').get(index), value: menu),
  ];
}
