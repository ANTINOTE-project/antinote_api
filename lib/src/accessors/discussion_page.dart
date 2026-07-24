import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/discussion/page.dart';

class DiscussionPageAccessor extends StatelessAccessor<DiscussionPage> {
  final bool showRead;
  final bool withMessages;

  const DiscussionPageAccessor({
    required this.showRead,
    required this.withMessages,
  });

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
            name: 'ListeMessagerie',
            dataSec: {
              session.stack.vocab.data: {
                'avecLu': showRead,
                'avecMessage': withMessages,
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
  FutureOr<DiscussionPage> interpretStateless(MapJsonNavigator nav) =>
      .decode(nav);

  @override
  List<VisualIdMixin> store(DiscussionPage result) => [...result.discussions];
}
