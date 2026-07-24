import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/notification/center.dart';

class NotificationCenterAccessor extends StatelessAccessor<NotificationCenter> {
  @override
  bool get exclusiveFriendly => true;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) async {
    return session.stack
        .post(
          Call.function(
            name: 'CentraleNotifications',
            dataSec: {},
            cancellationSignal: cancellationSignal,
          ),
        )
        .resultCompleter
        .future
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<NotificationCenter> interpretStateless(MapJsonNavigator nav) =>
      .decode(nav);

  @override
  List<VisualIdMixin> store(NotificationCenter result) => [];
}
