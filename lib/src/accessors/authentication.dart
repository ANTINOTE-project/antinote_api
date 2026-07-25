import 'dart:async';
import 'dart:typed_data';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/crypto.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/session_access_type.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/authentication_response.dart';

final class const AuthenticationAccessor({
  required final Uint8List challengeSolution,
}) extends StatelessAccessor<AuthenticationResponse> {
  @override
  bool get exclusiveFriendly => true;

  @override
  Future<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          Call.function(
            name: 'Authentification',
            dataSec: {
              session.stack.vocab.data: {
                'connexion': SessionAccessType.account.id,
                'challenge': challengeSolution.toHex(),
                'espace': session.stack.temporaryWorkspace.type.id,
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  AuthenticationResponse interpretStateless(MapJsonNavigator nav) =>
      .decode(nav);

  @override
  List<VisualIdMixin> store(AuthenticationResponse result) => [result];
}
