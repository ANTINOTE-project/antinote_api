import 'package:antinote/src/helpers/enum_id.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/news/display_mode.dart';
import 'package:antinote/src/models/news/news.dart';

final class const NewsCollection({
  required final List<News> news,
  required final NewsDisplayMode mode,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    news: nav.getLM('listeActualites').mapL((e) => .decode(e)),
    mode: NewsDisplayMode.values.byId(nav.get('G')),
  );
}
