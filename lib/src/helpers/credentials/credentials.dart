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

final _uuid = const Uuid();

typedef LoginResult = ({RemoteSession session, Credentials? credentials});

sealed class const Credentials({
  required final String deviceUuid,
  final String? navIdentifier,
}) {
  Workspace get workspace;

  Uri get baseUrl;

  static String generateDeviceUuid() {
    return _uuid.v4(config: const V4Options(null, CryptoRNG()));
  }

  Future<LoginResult> finalizeLogin({
    required RemoteSession session,
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
      throw const AuthException();
    }

    final authentication = await session.access(
      AuthenticationAccessor(challengeSolution: challengeSolution),
    );

    final authKey = await authentication.toAuthKey(
      session.stack.crypto,
      challengeWand,
    );
    await session.stack.crypto.setAesKey(authKey);

    await session.access(const UserParametersAccessor());

    session.stack.changeTab(7);
    session.currentUserResourceId = 0;

    return (
      session: session,
      credentials: authentication.relogToken != null
          ? TokenCredentials(
              cookies: [
                Cookie('uuidAppliMobile', deviceUuid),
                Cookie('appliMobile', '1'),
              ],
              username: challenge.username ?? username,
              token: authentication.relogToken!,
              workspace: workspace ?? session.instance.workspace,
              baseUrl: baseUrl,
              deviceUuid: deviceUuid,
              navIdentifier: /*session.instance.navigatorIdentifier ?? */
                  navIdentifier, // TODO: Find the exact scenario where navigatorIdentifier is present.
            )
          : null,
    );
  }

  Future<LoginResult> login({SessionOptions? options}) async {
    final session = await createSession(options ?? SessionOptions.getDefault());
    return loginBody(session);
  }

  Future<RemoteSession> createSession(SessionOptions options);

  Future<void> accessInstanceParameters(RemoteSession session) async {
    if (!session.hasAccessorNamed("InstanceParameters")) {
      await session.access(
        InstanceParametersAccessor(
          navIdentifier: navIdentifier,
          ivUuid: session.stack.generateIvUuid(),
        ),
      );
    }
  }

  Future<LoginResult> loginBody(RemoteSession session);
}
