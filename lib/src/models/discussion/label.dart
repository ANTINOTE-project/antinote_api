import 'package:antinote/src/helpers/json.dart';

final class DiscussionLabel {
  final String label;
  final String id;
  final int type;

  const DiscussionLabel({
    required this.label,
    required this.id,
    required this.type,
  });
}

extension AsDiscussionLabel on MapJsonNavigator {
  DiscussionLabel asDiscussionLabel() {
    return DiscussionLabel(label: get('L'), id: get('N'), type: get('G'));
  }
}
