part of 'credentials.dart';

final class const TokenCredentials({
  required final String username,
  required final String token,

  @override required final Workspace workspace,
  @override required final Uri baseUrl,
  required final List<Cookie> cookies,

  required super.deviceUuid,
  super.navIdentifier,
}) extends Credentials with SerializableObject<SerializedTokenCredentials> {
  factory TokenCredentials.restore(SerializedTokenCredentials serialized) {
    return TokenCredentials(
      username: serialized.username,
      token: serialized.token,
      workspace: Workspace.restore(serialized.workspace),
      baseUrl: Uri.parse(serialized.baseUrl),
      cookies: serialized.cookies.mapL((e) => Cookie.fromSetCookieValue(e)),
      deviceUuid: serialized.deviceUuid,
      navIdentifier: serialized.navIdentifier,
    );
  }

  factory TokenCredentials.restoreBinary(Uint8List data) =>
      TokenCredentials.restore(SerializedTokenCredentials.fromBuffer(data));

  factory TokenCredentials.restoreJson(String data) =>
      TokenCredentials.restore(SerializedTokenCredentials.fromJson(data));

  @override
  SerializedTokenCredentials serialize() {
    return SerializedTokenCredentials(
      username: username,
      token: token,
      workspace: workspace.serialize(),
      baseUrl: baseUrl.toString(),
      cookies: cookies.map((e) => e.toString()),
      deviceUuid: deviceUuid,
      navIdentifier: navIdentifier,
    );
  }

  @override
  Future<RemoteSession> createSession(SessionOptions options) =>
      RemoteSession.init(
        baseUrl,
        workspace: workspace,
        cookies: cookies,
        options: options,
      );

  @override
  Future<LoginResult> loginBody(RemoteSession session) async {
    await accessInstanceParameters(session);

    final challenge = await session.access(
      IdentificationAccessor.token(username: username, deviceUuid: deviceUuid),
    );

    return finalizeLogin(
      username: username,
      mod: token,
      challenge: challenge,
      session: session,
    );
  }
}
