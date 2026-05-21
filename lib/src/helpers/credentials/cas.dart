part of 'credentials.dart';

final class CasCredentials extends PasswordCredentials {
  static Future<LoginResult> loginFromTicketOrId(
    Uri uri,
    String? casToken,
    Workspace? workspace,
  ) async {
    final deviceUuid = Credentials.generateDeviceUuid();
    final session = await PronoteSession.init(
      uri,
      followRedirects: true,
      keepBaseUrl: true,
      parameters: {...PronoteSession.redirectBypassParameters},
      cookies: [
        if (casToken != null) Cookie('validationAppliMobile', casToken),
        Cookie('uuidAppliMobile', deviceUuid),
        Cookie('ielang', '1033'),
        // Cookie('appliMobile', '1'),
      ],
    );

    return CasCredentials(
      deviceUuid: deviceUuid,
      tokenId: session.stack.tokenId!,
      tokenKey: session.stack.tokenKey!,
      pronoteBaseUrl: session.stack.baseUrl,
      workspace: workspace ?? session.stack.temporaryWorkspace,
    ).loginBody(session);
  }

  const CasCredentials({
    required super.deviceUuid,
    super.navIdentifier,
    required String tokenId,
    required String tokenKey,
    required super.pronoteBaseUrl,
    required super.workspace,
  }) : super(username: tokenId, password: tokenKey);

  @override
  Future<LoginResult> loginBody(PronoteSession session) async {
    await accessInstanceParameters(session);

    final challenge = await session.access(
      IdentificationAccessor.cas(tokenId: username, deviceUuid: deviceUuid),
    );

    return finalizeLogin(
      username: username,
      addUsernameToWand: false,
      mod: password,
      challenge: challenge,
      session: session,
      workspace: workspace,
    );
  }
}
