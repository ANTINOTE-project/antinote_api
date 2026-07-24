import 'package:antinote/src/helpers/json.dart';

final class const TimeSlot({
  required final int index,
  required final String label,
  required final bool active,

  required final DateTime timing,
}) {
  factory decode(Map<String, dynamic> nav) {
    final [hour, minute] = nav
        .get<String>('L')
        .split('h')
        .sublist(0, 2)
        .mapL(int.parse);

    return .new(
      index: nav.get('G'),
      label: nav.get('L'),
      active: nav.getB('A'),
      timing: DateTime.utc(1970, 1, 1, hour, minute),
    );
  }
}
