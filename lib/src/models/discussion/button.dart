import 'package:antinote/src/helpers/json.dart';

final class DiscussionButton {
  final int type;
  final String label;

  const DiscussionButton({required this.type, required this.label});
}

extension AsDiscussionButton on MapJsonNavigator {
  DiscussionButton asDiscussionButton() {
    return DiscussionButton(type: get('G'), label: get('L'));
  }
}
