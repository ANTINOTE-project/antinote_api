import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/call/call.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/models/instance_parameters/shared.dart';

final class const InstanceParametersAccessor({
  final String? navIdentifier,
  final String? ivUuid,
  final String? casToken,
}) extends Accessor<InstanceParameters> {
  @override
  bool get exclusiveFriendly => true;

  @override
  int? get page => null;

  @override
  Future<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) => session.stack
      .post(
        .function(
          name: 'FonctionParametres',
          dataSec: {
            session.stack.vocab.data: {
              if (navIdentifier != null) 'identifiantNav': navIdentifier,
              if (ivUuid != null) 'Uuid': ivUuid,
            },
          },
          cancellationSignal: cancellationSignal,
          waitForResponse: false,
        ),
      )
      .thenField(session.stack.vocab.data);

  @override
  FutureOr<InstanceParameters> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) => .decode(nav, session.stack.temporaryWorkspace, casToken: casToken);

  @override
  List<VisualNavigator> store(InstanceParameters result) => [.stay(result)];
}
