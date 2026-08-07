import 'package:antinote_api/src/helpers/json.dart';

final class const Language({
  required final int id,
  required final String description,
}) {
  factory decode(Map<String, dynamic> nav) =>
      .new(id: nav.get('langID'), description: nav.get('description'));
}
