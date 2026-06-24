library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:antinote/antinote.dart';
import 'package:uuid/data.dart';
import 'package:uuid/rng.dart';
import 'package:uuid/uuid.dart';

part 'cas.dart';
part 'password.dart';
part 'qr_code.dart';
part 'token.dart';

final _uuid = Uuid();

typedef LoginResult = ({
  PronoteSession session,
  TokenCredentials refreshCredentials,
});

sealed class Credentials {
  Workspace get workspace;

  Uri get pronoteBaseUrl;

  final String deviceUuid;
  final String? navIdentifier;

  static String generateDeviceUuid() {
    return _uuid.v4(config: V4Options(null, CryptoRNG()));
  }

  Future<LoginResult> finalizeLogin({
    required PronoteSession session,
    required Challenge challenge,
    required String username,
    required String mod,
    bool addUsernameToWand = true,
    Workspace? workspace,
  }) async {
    session.stack.username = username;

    final challengeWand = await challenge.createWand(
      cLog: username,
      cMod: mod,
      crypto: session.stack.crypto,
      addUsernameToWand: addUsernameToWand,
    );
    final challengeSolution = await challenge.solve(
      challengeWand: challengeWand,
      crypto: session.stack.crypto,
    );

    if (challengeSolution == null) {
      throw AuthException();
    }

    final authentication = await session.access(
      AuthenticationAccessor(challengeSolution: challengeSolution),
    );

    final authKey = await authentication.toAuthKey(
      session.stack.crypto,
      challengeWand,
    );
    await session.stack.crypto.setAesKey(authKey);

    await session.access(UserParametersAccessor());

    session.stack.updateClientSignature({'onglet': 7});
    session.currentUserResourceId = 0;

    return (
      session: session,
      // TODO: Nullify refreshCredentials since it doesn't exist when on desktop
      refreshCredentials: TokenCredentials(
        cookies: [
          Cookie('uuidAppliMobile', deviceUuid),
          Cookie('appliMobile', '1'),
        ],
        username: challenge.username ?? username,
        token: authentication.relogToken ?? mod,
        workspace: workspace ?? session.instance.workspace,
        pronoteBaseUrl: pronoteBaseUrl,
        deviceUuid: deviceUuid,
        navIdentifier: /*session.instance.navigatorIdentifier ?? */
            navIdentifier, // TODO: Find the exact scenario where navigatorIdentifier is present.
      ),
    );
  }

  Future<LoginResult> login({SessionOptions? options}) async {
    final session = await createSession(options ?? SessionOptions.getDefault());
    await accessInstanceParameters(session);
    return loginBody(session);
  }

  Future<PronoteSession> createSession(SessionOptions options);

  Future<void> accessInstanceParameters(PronoteSession session) async {
    if (!session.hasAccessorNamed("InstanceParameters")) {
      await session.access(
        InstanceParametersAccessor(
          navIdentifier: navIdentifier,
          ivUuid: session.stack.generateIvUuid(),
        ),
      );
    }
  }

  Future<LoginResult> loginBody(PronoteSession session);

  const Credentials({required this.deviceUuid, this.navIdentifier});
}
