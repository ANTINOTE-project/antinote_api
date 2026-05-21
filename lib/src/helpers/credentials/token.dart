part of 'credentials.dart';

class TokenCredentials extends Credentials {
  final String username;
  final String token;

  @override
  final Workspace workspace;
  @override
  final Uri pronoteBaseUrl;
  final List<Cookie> cookies;

  const TokenCredentials({
    required this.username,
    required this.token,
    required this.workspace,
    required this.pronoteBaseUrl,
    required this.cookies,
    required super.deviceUuid,
    super.navIdentifier,
  });

  factory TokenCredentials.restore(SerializedTokenCredentials serialized) {
    return TokenCredentials(
      username: serialized.username,
      token: serialized.token,
      workspace: Workspace.restore(serialized.workspace),
      pronoteBaseUrl: Uri.parse(serialized.baseUrl),
      cookies: serialized.cookies.mapL((e) => Cookie.fromSetCookieValue(e)),
      deviceUuid: serialized.deviceUuid,
      navIdentifier: serialized.navIdentifier,
    );
  }

  factory TokenCredentials.restoreBinary(Uint8List data) =>
      TokenCredentials.restore(SerializedTokenCredentials.fromBuffer(data));

  factory TokenCredentials.restoreJson(String data) =>
      TokenCredentials.restore(SerializedTokenCredentials.fromJson(data));

  SerializedTokenCredentials serialize() {
    return SerializedTokenCredentials(
      username: username,
      token: token,
      workspace: workspace.serialize(),
      baseUrl: pronoteBaseUrl.toString(),
      cookies: cookies.map((e) => e.toString()),
      deviceUuid: deviceUuid,
      navIdentifier: navIdentifier,
    );
  }

  Map<String, dynamic> exportJson() => serialize().writeToJsonMap();

  String exportString() => serialize().writeToJson();

  Uint8List exportBinary() => serialize().writeToBuffer();

  @override
  Future<PronoteSession> createSession() => PronoteSession.init(
    pronoteBaseUrl,
    workspace: workspace,
    cookies: cookies,
  );

  @override
  Future<LoginResult> loginBody(PronoteSession session) async {
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
