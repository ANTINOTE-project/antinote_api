import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

import 'dish.dart';

const middayMeal = 0;
const eveningMeal = 1;

class Meal with VisualIdMixin {
  final String? title;
  final String id;
  final int mealType;
  final List<Dish> dishes;

  const Meal({
    required this.title,
    required this.id,
    required this.mealType,
    required this.dishes,
  });

  factory Meal.decode(MapJsonNavigator nav) {
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
  List<VisualIdMixin> get toStore => [
    for (final dish in dishes) ...[...dish.foods],
  ];
}
