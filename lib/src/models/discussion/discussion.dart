import 'package:antinote/antinote.dart';

final class const Discussion({
  required final List<DiscussionMessage> messages,
  required final DiscussionDraft draft,
  required final List<DiscussionButton> buttons,
  required final int messageRecipientCount,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    messages: nav.getLM('listeMessages').mapL((e) => .decode(e)),
    draft: DiscussionDraft.decode(nav.getM('messagePourReponse')),
    buttons: nav.getLM('listeBoutons').mapL((e) => .decode(e)),
    messageRecipientCount: nav.get('nbPossessionsMessage'),
  );
}
