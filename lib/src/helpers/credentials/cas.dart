part of 'credentials.dart';

final class const CasCredentials({
  required super.deviceUuid,
  super.navIdentifier,
  required final String tokenId,
  required final String tokenKey,
  required super.baseUrl,
  required super.cookies,
  required super.workspace,
}) extends PasswordCredentials {
  this : super(username: tokenId, password: tokenKey);

  static Future<LoginResult> loginFromTicketOrId(
    Uri uri,
    String? casToken,
    Workspace? workspace,
    String? locale,
  ) async {
    final deviceUuid = Credentials.generateDeviceUuid();
    final session = await RemoteSession.init(
      uri,
      followRedirects: true,
      keepBaseUrl: true,
      parameters: {...RemoteSession.redirectBypassParameters},
      cookies: [
        if (casToken != null) Cookie('validationAppliMobile', casToken),
        Cookie('uuidAppliMobile', deviceUuid),
        // Cookie('appliMobile', '1'),
      ],
      options: SessionOptions(locale: locale),
    );

    return CasCredentials(
      deviceUuid: deviceUuid,
      tokenId: session.stack.tokenId!,
      tokenKey: session.stack.tokenKey!,
      baseUrl: session.stack.baseUrl,
      cookies: session.stack.cookies,
      workspace: workspace ?? session.stack.temporaryWorkspace,
    ).loginBody(session);
  }

  @override
  Future<LoginResult> loginBody(RemoteSession session) async {
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
