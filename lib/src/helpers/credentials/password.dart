part of 'credentials.dart';

class PasswordCredentials extends Credentials {
  final String username;
  final String password;

  @override
  final Workspace workspace;

  @override
  /// Stops at /pronote
  final Uri pronoteBaseUrl;

  const PasswordCredentials({
    required this.username,
    required this.password,
    required this.workspace,
    required this.pronoteBaseUrl,
    required super.deviceUuid,
    super.navIdentifier,
  });

  @override
  Future<PronoteSession> createSession(SessionOptions options) =>
      PronoteSession.init(
        pronoteBaseUrl,
        workspace: workspace,
        parameters: {
          ...PronoteSession.baseParameters,
          'bydlg': 'A6ABB224-12DD-4E31-AD3E-8A39A1C2C335',
        },
        options: options,
      );

  @override
  Future<LoginResult> loginBody(PronoteSession session) async {
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
