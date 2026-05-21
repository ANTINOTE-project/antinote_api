import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/discussion/button.dart';
import 'package:antinote/src/models/discussion/draft.dart';
import 'package:antinote/src/models/discussion/message.dart';

final class Discussion {
  final List<DiscussionMessage> messages;
  final DiscussionDraft draft;
  final List<DiscussionButton> buttons;
  final int messageRecipientCount;

  const Discussion({
    required this.messages,
    required this.draft,
    required this.buttons,
    required this.messageRecipientCount,
  });
}

extension AsDiscussion on MapJsonNavigator {
  Discussion asDiscussion() {
    return Discussion(
      messages: getLM('listeMessages').mapL((e) => e.asDiscussionMessage()),
      draft: getM('messagePourReponse').asDiscussionDraft(),
      buttons: getLM('listeBoutons').mapL((e) => e.asDiscussionButton()),
      messageRecipientCount: get('nbPossessionsMessage'),
    );
  }
}
