import 'package:antinote/src/helpers/json.dart';

final class Language {
  final int id;
  final String description;

  const Language({required this.id, required this.description});
}

extension AsLanguage on MapJsonNavigator {
  Language asLanguage() {
    return Language(id: get('langID'), description: get('description'));
  }
}
