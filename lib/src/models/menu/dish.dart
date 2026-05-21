import 'package:antinote/src/helpers/json.dart';

import 'food.dart';

class Dish {
  final List<Food> foods;

  // This is not the order for the dishes, only its type (which is undocumented)
  final int index;

  const Dish({required this.foods, required this.index});

  factory Dish.decode(MapJsonNavigator nav) {
    return Dish(
      foods: nav.eGetLM(['listeAliments', 'ListeAliments'])!.mapL(Food.decode),
      index: nav.get('G'),
    );
  }
}
