import 'package:antinote/antinote.dart';

final class const Pause({
  required final String label,
  required final int slot,
}) {
  factory decode(Map<String, dynamic> nav) =>
      .new(label: nav.get('L'), slot: nav.get('place'));
}
