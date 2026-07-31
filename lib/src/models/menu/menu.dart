import 'package:antinote/src/helpers/json.dart';

import 'meal.dart';

class Menu({required final DateTime time, required final List<Meal> meals}) {
  factory Menu.decode(Map<String, dynamic> nav, {DateTime? time}) {
    return Menu(
      meals: nav.eGetLM(['listeRepas', 'ListeRepas'])!.mapL(Meal.decode),
      time: time ?? nav.get('Date'),
    );
  }
}
