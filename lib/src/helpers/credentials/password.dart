part of 'credentials.dart';

final class const PasswordCredentials({
  required final String username,
  required final String password,

  @override required final Workspace workspace,

  @override
  /// Stops at `/<product_name>`
  required final Uri baseUrl,
  required final List<Cookie> cookies,

  required super.deviceUuid,
  super.navIdentifier,
}) extends Credentials {
  factory PasswordCredentials.restore(
    SerializedPasswordCredentials serialized,
  ) {
    return PasswordCredentials(
      username: serialized.username,
      password: serialized.password,
      workspace: Workspace.restore(serialized.workspace),
      baseUrl: Uri.parse(serialized.baseUrl),
      cookies: serialized.cookies.mapL((e) => Cookie.fromSetCookieValue(e)),
      deviceUuid: serialized.deviceUuid,
      navIdentifier: serialized.navIdentifier,
    );
  }

  factory PasswordCredentials.restoreBinary(Uint8List data) =>
      PasswordCredentials.restore(
        SerializedPasswordCredentials.fromBuffer(data),
      );

  factory PasswordCredentials.restoreJson(String data) =>
      PasswordCredentials.restore(SerializedPasswordCredentials.fromJson(data));

  SerializedPasswordCredentials serialize() {
    return SerializedPasswordCredentials(
      username: username,
      password: password,
      workspace: workspace.serialize(),
      baseUrl: baseUrl.toString(),
      cookies: cookies.map((e) => e.toString()),
      deviceUuid: deviceUuid,
      navIdentifier: navIdentifier,
    );
  }

  Map<String, dynamic> exportJson() => serialize().writeToJsonMap();

  String exportString() => serialize().writeToJson();

  Uint8List exportBinary() => serialize().writeToBuffer();

  @override
  Future<RemoteSession> createSession(SessionOptions options) =>
      RemoteSession.init(
        baseUrl,
        workspace: workspace,
        parameters: {
          ...RemoteSession.baseParameters,
          'bydlg': 'A6ABB224-12DD-4E31-AD3E-8A39A1C2C335',
        },
        options: options,
      );

  @override
  Future<LoginResult> loginBody(RemoteSession session) async {
    await accessInstanceParameters(session);

    final challenge = await session.access(
      IdentificationAccessor.password(
        username: username,
        deviceUuid: deviceUuid,
      ),
    );

    return finalizeLogin(
      username: username,
      mod: password,
      challenge: challenge,
      session: session,
    );
  }
}
