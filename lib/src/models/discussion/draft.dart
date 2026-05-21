import 'package:antinote/src/helpers/json.dart';

final class DiscussionDraft {
  final String id;
  final int type;
  final bool closed;
  final int? recipientCount;
  final String? informationMessage;

  const DiscussionDraft({
    required this.id,
    required this.type,
    required this.closed,
    required this.recipientCount,
    required this.informationMessage,
  });
}

extension AsDiscussionDraft on MapJsonNavigator {
  DiscussionDraft asDiscussionDraft() {
    return DiscussionDraft(
      id: get('N'),
      type: get('G'),
      closed: get('ferme') ?? false,
      recipientCount: get('nbDestinataires'),
      informationMessage: get('messageInfo'),
    );
  }
}
