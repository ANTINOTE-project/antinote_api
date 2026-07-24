import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/news/category.dart';
import 'package:antinote/src/models/news/collection.dart';

final class const NewsPage({
  required final List<NewsCollection> collections,
  required final List<NewsCategory> categories,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    collections: nav.getLM('listeModesAff').mapL((e) => .decode(e)),
    categories: nav.getLM('listeCategories').mapL((e) => .decode(e)),
  );
}
