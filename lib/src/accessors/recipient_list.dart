import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/person.dart';

class RecipientListAccessor extends StatelessAccessor<List<Person>> {
  final String messageId;
  final bool _estPublicParticipant;
  final bool _estDestinatairesReponse;

  RecipientListAccessor.receivers({required this.messageId})
    : _estDestinatairesReponse = false,
      _estPublicParticipant = false;

  RecipientListAccessor.participants({required this.messageId})
    : _estDestinatairesReponse = false,
      _estPublicParticipant = true;

  @override
  bool get exclusiveFriendly => false;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          Call.function(
            name: 'SaisiePublicMessage',
            dataSec: {
              session.stack.vocab.data: {
                'estPublicParticipant': _estPublicParticipant,
                'estDestinatairesReponse': _estDestinatairesReponse,
                'message': {'N': messageId},
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .resultCompleter
        .future
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<List<Person>> interpretStateless(MapJsonNavigator nav) {
    return nav.getLM('listeDest').mapL((e) => .decode(e));
  }

  @override
  List<VisualIdMixin> store(List<Person> result) => [...result];
}
