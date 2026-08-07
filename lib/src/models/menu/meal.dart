import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';

import 'dish.dart';

const middayMeal = 0;
const eveningMeal = 1;

final class const Meal({
  required final String? title,
  required final String id,
  required final int mealType,
  required final List<Dish> dishes,
}) with VisualIdMixin {
  factory Meal.decode(Map<String, dynamic> nav) {
    return Meal(
      title: nav.get('L'),
      id: nav.get('N'),
      mealType: nav.get('G'),
      dishes: nav.eGetLM(['listePlats', 'ListePlats'])!.mapL(Dish.decode),
    );
  }

  @override
  CacheType? get cacheType => .MEAL;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield title?.visualIdData();
    yield mealType.byteVisualIdData();
    yield* dishes
        .map((e) => e.foods.visualIdForEach())
        .fold([], (previousValue, element) => [...previousValue, ...element]);
  }

  @override
  List<VisualNavigator> get toStore => [
    for (final (index, dish) in dishes.indexed)
      .new(
        exchanger: (nav) =>
            nav.eGetLM(['listePlats', 'ListePlats'])!.get(index),
        value: dish,
      ),
  ];
}
