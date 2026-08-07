import 'dart:typed_data';

import 'package:antinote_api/antinote_api.dart';

final class const Discussion({
  required final List<DiscussionMessage> messages,
  required final DiscussionDraft draft,
  required final List<DiscussionButton> buttons,
  required final int messageRecipientCount,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    messages: nav.getLM('listeMessages').mapL((e) => .decode(e)),
    draft: .decode(nav.getM('messagePourReponse')),
    buttons: nav.getLM('listeBoutons').mapL((e) => .decode(e)),
    messageRecipientCount: nav.get('nbPossessionsMessage'),
  );

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* messages.visualIdForEach();
  }

  @override
  List<VisualNavigator> get toStore => [
    ...messages.indexed
        .map(
          (e) => VisualNavigator(
            exchanger: (nav) => nav.getLM('listeMessages').get(e.$1),
            value: e.$2,
          ),
        )
        .toList(growable: false),
  ];
}
