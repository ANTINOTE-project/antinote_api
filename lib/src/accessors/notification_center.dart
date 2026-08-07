import 'dart:async';

import 'package:antinote_api/src/accessors/accessors.dart';
import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/network_stack.dart';
import 'package:antinote_api/src/helpers/session.dart';
import 'package:antinote_api/src/models/notification/center.dart';

final class const NotificationCenterAccessor()
    extends Accessor<NotificationCenter> {
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
  FutureOr<NotificationCenter> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) => .decode(nav);

  @override
  List<VisualNavigator> store(NotificationCenter result) => [];
}
