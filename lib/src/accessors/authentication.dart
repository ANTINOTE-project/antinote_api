import 'dart:async';
import 'dart:typed_data';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/crypto.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session_access_type.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/authentication_response.dart';

class AuthenticationAccessor extends StatelessAccessor<AuthenticationResponse> {
  final Uint8List challengeSolution;

  const AuthenticationAccessor({required this.challengeSolution});

  @override
  bool get exclusiveFriendly => true;

  @override
  Future<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) {
    return stack
        .post(
          Call.function(
            name: 'Authentification',
            dataSec: {
              stack.vocab.data: {
                'connexion': SessionAccessType.account.id,
                'challenge': challengeSolution.toHex(),
                'espace': stack.temporaryWorkspace.type.id,
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .thenField(stack.vocab.data);
  }

  @override
  AuthenticationResponse interpretStateless(MapJsonNavigator nav) =>
      nav.asAuthenticationResponse();

  @override
  List<VisualIdMixin> store(AuthenticationResponse result) => [result];
}
