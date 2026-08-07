import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/enum_id.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';
import 'package:antinote_api/src/models/news/category.dart';
import 'package:antinote_api/src/models/news/collection.dart';
import 'package:antinote_api/src/models/news/question/question.dart';

enum NewsPageRequestType(@override final int id) implements EnumId {
  display(0),
  details(1)
}

final class const NewsPage({
  required final List<NewsCollection> collections,
  required final List<NewsCategory> categories,

  required final NewsPageRequestType type,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    collections: nav.getLM('listeModesAff').mapL((e) => .decode(e)),
    categories: nav
        .eGetLM(['listeCategories', 'listeNatures'])!
        .mapL((e) => .decode(e)),
    type: nav.has('genreRequeteActualite')
        ? .values.byId(nav.get('genreRequeteActualite'))
        : .display,
  );

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* categories.visualIdForEach();
    yield* collections.visualIdForEach();
  }

  @override
  List<VisualNavigator> get toStore => [
    for (final (index, category) in categories.indexed)
      .eIndexed(
        category,
        possibleFields: ['listeCategories', 'listeNatures'],
        index: index,
      ),
    for (final (index, collection) in collections.indexed)
      .indexed(collection, field: 'listeModesAff', index: index),
  ];
}

final class const NewsContent({
  required final NewsPageRequestType type,
  required final List<NewsQuestion> questions,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    type: .values.byId(nav.get('genreRequeteActualite')),
    questions: nav
        .getM('detailsActualite')
        .getLM('listeQuestions')
        .mapL((e) => .decode(e)),
  );
}
