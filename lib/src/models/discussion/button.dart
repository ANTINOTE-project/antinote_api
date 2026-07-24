import 'package:antinote/src/helpers/json.dart';

final class const DiscussionButton({
  required final int type,
  required final String label,
}) {
  factory decode(Map<String, dynamic> nav) =>
      .new(type: nav.get('G'), label: nav.get('L'));
}
