import 'package:antinote/src/helpers/json.dart';

import 'meal.dart';

class Menu {
  final DateTime time;
  final List<Meal> meals;

  const Menu({required this.meals, required this.time});

  factory Menu.decode(MapJsonNavigator nav, {DateTime? time}) {
    return Menu(
      meals: nav.eGetLM(['listeRepas', 'ListeRepas'])!.mapL(Meal.decode),
      time: time ?? nav.get('Date'),
    );
  }
}
