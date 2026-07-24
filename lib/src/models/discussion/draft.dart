import 'package:antinote/src/helpers/json.dart';

final class const DiscussionDraft({
  required final String id,
  required final int type,
  required final bool closed,
  required final int? recipientCount,
  required final String? informationMessage,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    type: nav.get('G'),
    closed: nav.get('ferme') ?? false,
    recipientCount: nav.get('nbDestinataires'),
    informationMessage: nav.get('messageInfo'),
  );
}
