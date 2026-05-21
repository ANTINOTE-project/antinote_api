import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/menu/food_allergen.dart';
import 'package:antinote/src/models/menu/food_label.dart';
import 'package:antinote/src/models/menu/menu.dart';

final class MenuPage {
  final bool withMiddayMeal;
  final bool withEveningMeal;
  final List<FoodAllergen> allergens;
  final List<FoodLabel> labels;
  final List<int> availableWeeks;
  final List<Menu> menus;

  const MenuPage({
    required this.withMiddayMeal,
    required this.withEveningMeal,
    required this.allergens,
    required this.labels,
    required this.availableWeeks,
    required this.menus,
  });
}

extension AsMenuPage on MapJsonNavigator {
  MenuPage asMenuPage() {
    return MenuPage(
      withMiddayMeal: get('AvecRepasMidi'),
      withEveningMeal: get('AvecRepasSoir'),
      allergens: getLM('ListeAllergenes').mapL((e) => FoodAllergen.decode(e)),
      labels: getLM('Listelabels').mapL((e) => FoodLabel.decode(e)),
      // TODO: Check if this is right
      availableWeeks: get('DomaineDePresence'),
      menus: getLM('ListeJours').mapL((e) => Menu.decode(e)),
    );
  }
}
