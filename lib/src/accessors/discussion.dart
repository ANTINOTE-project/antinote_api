import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/discussion/discussion.dart';
import 'package:antinote/src/models/discussion/node.dart';

class DiscussionAccessor extends StatelessAccessor<Discussion> {
  final DiscussionRootNode node;
  final bool markAsRead;

  const DiscussionAccessor({required this.node, this.markAsRead = true});

  @override
  bool get exclusiveFriendly => true;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          Call.function(
            name: 'ListeMessages',
            dataSec: {
              session.stack.vocab.data: {
                'estNonPossede': node.isNotARecipient,
                'listePossessionsMessages': node.recipients.mapL(
                  (e) => {'N': e.id},
                ),
                // TODO: Add flag for that
                'marquerCommeLu': markAsRead,
                'message': {'N': int.tryParse(node.id) ?? node.id},
                'nbMessagesVus': 20,
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
  FutureOr<Discussion> interpretStateless(MapJsonNavigator nav) =>
      nav.asDiscussion();

  @override
  List<VisualIdMixin> store(Discussion result) => [...result.messages];
}
