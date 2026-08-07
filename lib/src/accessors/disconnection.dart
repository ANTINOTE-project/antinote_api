import 'dart:async';

import 'package:antinote_api/src/accessors/accessors.dart';
import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/call/call.dart';
import 'package:antinote_api/src/helpers/session.dart';

final class DisconnectionAccessor extends Accessor<void> {
  final bool logged;

  const DisconnectionAccessor.logged() : logged = true;

  const DisconnectionAccessor.unlogged() : logged = false;

  @override
  bool get exclusiveFriendly => true;

  @override
  int? get page => null;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          logged
              ? .function(
                  cancellationSignal: cancellationSignal,
                  dataSec: {},
                  name: 'SaisieDeconnexion',
                )
              : Call.disconnection(cancellationSignal: cancellationSignal),
        )
        .resultCompleter
        .future;
  }

  @override
  FutureOr<void> interpret(Map<String, dynamic> nav, RemoteSession session) =>
      null;

  @override
  List<VisualNavigator> store(void result) => [];
}
