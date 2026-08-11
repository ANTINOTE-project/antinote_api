import 'dart:async';

import 'package:antinote_api/src/accessors/accessors.dart';
import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/network_stack.dart';
import 'package:antinote_api/src/helpers/session.dart';
import 'package:antinote_api/src/models/discussion/page.dart';

final class const DiscussionPageAccessor({
  required final bool showRead,
  required final bool withMessages,
}) extends Accessor<DiscussionPage> {
  @override
  bool get exclusiveFriendly => true;

  static const int pageId = 131;

  @override
  int? get page => pageId;

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
  FutureOr<DiscussionPage> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) => .decode(nav);

  @override
  List<VisualNavigator> store(DiscussionPage result) => [.stay(result)];
}
