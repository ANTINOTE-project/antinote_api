import 'package:antinote/src/helpers/enum_id.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/news/category.dart';
import 'package:antinote/src/models/news/collection.dart';
import 'package:antinote/src/models/news/question/question.dart';

enum NewsPageRequestType(@override final int id) implements EnumId {
  display(0),
  details(1)
}

final class const NewsPage({
  required final List<NewsCollection> collections,
  required final List<NewsCategory> categories,

  required final NewsPageRequestType type,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    collections: nav.getLM('listeModesAff').mapL((e) => .decode(e)),
    categories: nav
        .eGetLM(['listeCategories', 'listeNatures'])!
        .mapL((e) => .decode(e)),
    type: nav.has('genreRequeteActualite')
        ? .values.byId(nav.get('genreRequeteActualite'))
        : .display,
  );
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
