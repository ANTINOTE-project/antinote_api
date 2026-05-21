import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/news/category.dart';
import 'package:antinote/src/models/news/collection.dart';

final class NewsPage {
  final List<NewsCollection> collections;
  final List<NewsCategory> categories;

  const NewsPage({required this.collections, required this.categories});
}

extension AsNewsPage on MapJsonNavigator {
  NewsPage asNewsPage() {
    return NewsPage(
      collections: getLM('listeModesAff').mapL((e) => e.asNewsCollection()),
      categories: getLM('listeCategories').mapL((e) => e.asNewsCategory()),
    );
  }
}
