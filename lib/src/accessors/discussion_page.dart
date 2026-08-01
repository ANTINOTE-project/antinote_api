import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/models/discussion/page.dart';

final class const DiscussionPageAccessor({
  required final bool showRead,
  required final bool withMessages,
}) extends StatelessAccessor<DiscussionPage> {
  @override
  bool get exclusiveFriendly => true;

  @override
  int? get page => 131;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
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
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<DiscussionPage> interpretStateless(Map<String, dynamic> nav) =>
      .decode(nav);

  @override
  List<VisualNavigator> store(DiscussionPage result) => [.stay(result)];
}
