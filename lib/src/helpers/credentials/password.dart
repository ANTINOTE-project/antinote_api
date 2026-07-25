part of 'credentials.dart';

class PasswordCredentials extends Credentials {
  final String username;
  final String password;

  @override
  final Workspace workspace;

  @override
  /// Stops at `/<product_name>`
  final Uri baseUrl;

  const PasswordCredentials({
    required this.username,
    required this.password,
    required this.workspace,
    required this.baseUrl,
    required super.deviceUuid,
    super.navIdentifier,
  });

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
