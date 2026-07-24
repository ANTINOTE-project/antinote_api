import 'package:antinote/src/helpers/json.dart';

final class const Break({
  required final String name,
  required final int daySlot,
}) {
  factory decode(Map<String, dynamic> nav) =>
      .new(name: nav.get('L'), daySlot: nav.get('place'));
}
