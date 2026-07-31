part of 'credentials.dart';

final class const QrCodeCredentials({
  required final String encryptedUsername,
  required final String encryptedToken,
  required final String pin,

  @override required final Workspace workspace,
  @override required final Uri baseUrl,

  required super.deviceUuid,
  super.navIdentifier,
}) extends Credentials {
  static Future<LoginResult> loginFromQrCode(
    String qrCode,
    String pin, {
    String? deviceUuid,
  }) async {
    final parsedQrCode = Map<String, dynamic>.from(jsonDecode(qrCode));

    var baseUrl = Uri.parse(parsedQrCode.get<String>('url'));
    final urlPathSegment = baseUrl.pathSegments
        .toList()
        .skipWhile((value) => value != 'pronote')
        .skip(1)
        .first;

    final tempWorkspace = Workspace(
      type: WorkspaceType.mobileCommun,
      label: urlPathSegment,
      pathSegment: urlPathSegment,
    );
    baseUrl = baseUrl.replace(
      pathSegments: [
        ...baseUrl.pathSegments.takeWhile((value) => value != 'pronote'),
        'pronote',
      ],
    );

    deviceUuid ??= Credentials.generateDeviceUuid();

    final tempCredentials = QrCodeCredentials(
      encryptedUsername: parsedQrCode.get('login'),
      encryptedToken: parsedQrCode.get('jeton'),
      workspace: tempWorkspace,
      baseUrl: baseUrl,
      pin: pin,
      deviceUuid: deviceUuid,
    );

    return tempCredentials.login();
  }

  @override
  Future<RemoteSession> createSession(SessionOptions options) =>
      RemoteSession.init(
        baseUrl,
        workspace: workspace,
        cookies: [Cookie('appliMobile', '1')],
        options: options,
      );

  @override
  Future<LoginResult> loginBody(RemoteSession session) async {
    await accessInstanceParameters(session);

    final pinWand = await session.stack.crypto.createAesWand(utf8.encode(pin));

    final realUsername = utf8.decode(
      await session.stack.crypto.aesDecrypt(
        encryptedUsername.fromHex(),
        ivMode: IvMode.zeros,
        auxiliaryWand: pinWand,
      ),
      allowMalformed: true,
    );

    final realToken = utf8.decode(
      await session.stack.crypto.aesDecrypt(
        encryptedToken.fromHex(),
        ivMode: IvMode.zeros,
        auxiliaryWand: pinWand,
      ),
      allowMalformed: true,
    );

    final challenge = await session.access(
      IdentificationAccessor.qrCode(
        username: realUsername,
        deviceUuid: deviceUuid,
      ),
    );

    return finalizeLogin(
      username: realUsername,
      mod: realToken,
      challenge: challenge,
      session: session,
    );
  }
}
