import 'dart:async';
import 'dart:typed_data';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/crypto.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/session_access_type.dart';
import 'package:antinote/src/models/authentication_response.dart';

final class const AuthenticationAccessor({
  required final Uint8List challengeSolution,
}) extends Accessor<AuthenticationResponse> {
  @override
  bool get exclusiveFriendly => true;

  @override
  int? get page => null;

  @override
  Future<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
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
  AuthenticationResponse interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) => .decode(nav);

  @override
  List<VisualNavigator> store(AuthenticationResponse result) => [.stay(result)];
}
