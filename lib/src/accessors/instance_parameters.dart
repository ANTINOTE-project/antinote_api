import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/instance_parameters/shared.dart';
import 'package:antinote/src/models/workspace/workspace.dart';

final class const InstanceParametersAccessor({
  final String? navIdentifier,
  final String? ivUuid,
  final String? casToken,
}) extends StatefulAccessor<InstanceParameters, Workspace> {
  @override
  bool get exclusiveFriendly => true;

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
  FutureOr<Workspace> collectState(RemoteSession session) =>
      session.stack.temporaryWorkspace;

  @override
  FutureOr<InstanceParameters> interpret(
    MapJsonNavigator<dynamic> nav,
    Workspace tempWorkspace,
  ) => .decode(nav, tempWorkspace, casToken: casToken);

  @override
  List<VisualIdMixin> store(InstanceParameters result) => [result];
}
