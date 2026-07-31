import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/call/call.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';

final class DisconnectionAccessor extends StatelessAccessor<void> {
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
  FutureOr<void> interpretStateless(Map<String, dynamic> nav) => null;

  @override
  List<VisualIdMixin> store(void result) => [];
}
