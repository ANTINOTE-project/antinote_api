import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/visual_id.dart';

class DisconnectionAccessor extends StatelessAccessor<void> {
  final bool logged;

  const DisconnectionAccessor.logged() : logged = true;

  const DisconnectionAccessor.unlogged() : logged = false;

  @override
  FutureOr<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) {
    return stack
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
