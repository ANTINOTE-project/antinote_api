import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/instance_parameters/shared.dart';
import 'package:antinote/src/models/workspace/workspace.dart';

class InstanceParametersAccessor
    extends StatefulAccessor<InstanceParameters, Workspace> {
  final String? navIdentifier;
  final String? ivUuid;
  final String? casToken;

  const InstanceParametersAccessor({
    this.navIdentifier,
    this.ivUuid,
    this.casToken,
  });

  @override
  bool get exclusiveFriendly => true;

  @override
  Future<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) => stack
      .post(
        Call.function(
          name: 'FonctionParametres',
          dataSec: {
            stack.vocab.data: {
              if (navIdentifier != null) 'identifiantNav': navIdentifier,
              if (ivUuid != null) 'Uuid': ivUuid,
            },
          },
          cancellationSignal: cancellationSignal,
          waitForResponse: false,
        ),
      )
      .thenField(stack.vocab.data);

  @override
  FutureOr<Workspace> collectState(RemoteSession session) =>
      session.stack.temporaryWorkspace;

  @override
  FutureOr<InstanceParameters> interpret(
    MapJsonNavigator<dynamic> nav,
    Workspace tempWorkspace,
  ) => nav.asInstanceParameters(tempWorkspace, casToken: casToken);

  @override
  List<VisualIdMixin> store(InstanceParameters result) => [result];
}
