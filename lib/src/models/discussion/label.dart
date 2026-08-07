import 'package:antinote_api/src/helpers/json.dart';

final class const DiscussionLabel({
  required final String label,
  required final String id,
  required final int type,
}) {
  factory decode(Map<String, dynamic> nav) =>
      .new(label: nav.get('L'), id: nav.get('N'), type: nav.get('G'));
}
