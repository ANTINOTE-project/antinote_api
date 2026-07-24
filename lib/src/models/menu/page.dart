import 'package:antinote/src/helpers/json.dart';
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
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    withMiddayMeal: nav.get('AvecRepasMidi'),
    withEveningMeal: nav.get('AvecRepasSoir'),
    allergens: nav.getLM('ListeAllergenes').mapL((e) => FoodAllergen.decode(e)),
    labels: nav.getLM('Listelabels').mapL((e) => FoodLabel.decode(e)),
    // TODO: Check if this is right
    availableWeeks: nav.get('DomaineDePresence'),
    menus: nav.getLM('ListeJours').mapL((e) => Menu.decode(e)),
  );
}
