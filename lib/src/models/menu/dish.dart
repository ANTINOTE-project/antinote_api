import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';

import 'food.dart';

final class const Dish({
  required final List<Food> foods,

  /// This is not the order for the dishes, only its type (which is undocumented)
  required final int index,
}) with VisualIdMixin {
  factory Dish.decode(Map<String, dynamic> nav) {
    return Dish(
      foods: nav.eGetLM(['listeAliments', 'ListeAliments'])!.mapL(Food.decode),
      index: nav.get('G'),
    );
  }

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* foods.visualIdForEach();
  }

  @override
  List<VisualNavigator> get toStore => [
    for (final (index, food) in foods.indexed)
      .new(
        exchanger: (nav) =>
            nav.eGetLM(['listeAliments', 'ListeAliments'])!.get(index),
        value: food,
      ),
  ];
}
