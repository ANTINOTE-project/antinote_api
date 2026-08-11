import 'dart:async';

import 'package:antinote_api/src/accessors/accessors.dart';
import 'package:antinote_api/src/accessors/discussion_page.dart';
import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/network_stack.dart';
import 'package:antinote_api/src/helpers/session.dart';
import 'package:antinote_api/src/models/person.dart';

final class RecipientListAccessor extends Accessor<List<Person>> {
  final String messageId;
  final bool isParticipant;
  final bool isResponseRecipient;

  RecipientListAccessor.receivers({required this.messageId})
    : isResponseRecipient = false,
      isParticipant = false;

  RecipientListAccessor.participants({required this.messageId})
    : isResponseRecipient = false,
      isParticipant = true;

  @override
  bool get exclusiveFriendly => false;

  @override
  int? get page => DiscussionPageAccessor.pageId;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
            name: 'SaisiePublicMessage',
            dataSec: {
              session.stack.vocab.data: {
                'estPublicParticipant': isParticipant,
                'estDestinatairesReponse': isResponseRecipient,
                'message': {'N': messageId},
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<List<Person>> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) {
    return nav.getLM('listeDest').mapL((e) => .decode(e));
  }

  @override
  List<VisualNavigator> store(List<Person> result) => [
    for (final (index, person) in result.indexed)
      .indexed(person, field: 'listeDest', index: index),
  ];
}
