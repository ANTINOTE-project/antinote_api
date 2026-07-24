import 'package:antinote/src/helpers/json.dart';

import 'food.dart';

final class const Dish({
  required final List<Food> foods,

  /// This is not the order for the dishes, only its type (which is undocumented)
  required final int index,
}) {
  factory Dish.decode(MapJsonNavigator nav) {
    return Dish(
      foods: nav.eGetLM(['listeAliments', 'ListeAliments'])!.mapL(Food.decode),
      index: nav.get('G'),
    );
  }
}
