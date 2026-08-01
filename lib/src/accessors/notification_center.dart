import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/models/notification/center.dart';

final class const NotificationCenterAccessor()
    extends StatelessAccessor<NotificationCenter> {
  @override
  bool get exclusiveFriendly => true;

  @override
  int? get page => null;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) async {
    return session.stack
        .post(
          .function(
            name: 'CentraleNotifications',
            dataSec: {},
            cancellationSignal: cancellationSignal,
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<NotificationCenter> interpretStateless(Map<String, dynamic> nav) =>
      .decode(nav);

  @override
  List<VisualNavigator> store(NotificationCenter result) => [];
}
