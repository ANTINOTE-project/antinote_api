import 'package:antinote/src/helpers/enum_id.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/news/display_mode.dart';
import 'package:antinote/src/models/news/news.dart';

final class NewsCollection {
  final List<News> news;
  final NewsDisplayMode mode;

  const NewsCollection({required this.news, required this.mode});
}

extension AsNewsCollection on MapJsonNavigator {
  NewsCollection asNewsCollection() {
    return NewsCollection(
      news: getLM('listeActualites').mapL((e) => e.asNews()),
      mode: NewsDisplayMode.values.byId(get('G')),
    );
  }
}
