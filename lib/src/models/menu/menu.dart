import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';

import 'meal.dart';

class Menu({required final DateTime time, required final List<Meal> meals})
    with VisualIdMixin {
  factory Menu.decode(Map<String, dynamic> nav, {DateTime? time}) {
    return Menu(
      meals: nav.eGetLM(['listeRepas', 'ListeRepas'])!.mapL(Meal.decode),
      time: time ?? nav.get('Date'),
    );
  }

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* meals.visualIdForEach();
  }

  @override
  List<VisualNavigator> get toStore => [
    for (final (index, meal) in meals.indexed)
      .new(
        exchanger: (nav) =>
            nav.eGetLM(['listeRepas', 'ListeRepas'])!.get(index),
        value: meal,
      ),
  ];
}
