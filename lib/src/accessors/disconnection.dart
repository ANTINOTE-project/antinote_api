import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';

final class DisconnectionAccessor extends StatelessAccessor<void> {
  final bool logged;

  const DisconnectionAccessor.logged() : logged = true;

  const DisconnectionAccessor.unlogged() : logged = false;

  @override
  bool get exclusiveFriendly => true;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          logged
              ? Call.function(
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
  FutureOr<void> interpretStateless(MapJsonNavigator<dynamic> nav) => null;

  @override
  List<VisualIdMixin> store(void result) => [];
}
