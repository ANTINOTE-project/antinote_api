part of 'credentials.dart';

class QrCodeCredentials extends Credentials {
  final String encryptedUsername;
  final String encryptedToken;
  final String pin;

  @override
  final Workspace workspace;
  @override
  final Uri baseUrl;

  const QrCodeCredentials({
    required this.encryptedUsername,
    required this.encryptedToken,
    required this.pin,
    required this.workspace,
    required this.baseUrl,
    required super.deviceUuid,
    super.navIdentifier,
  });

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
