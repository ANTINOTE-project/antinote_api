part of 'credentials.dart';

class QrCodeCredentials extends Credentials {
  final String encryptedUsername;
  final String encryptedToken;
  final String pin;

  @override
  final Workspace workspace;
  @override
  final Uri pronoteBaseUrl;

  const QrCodeCredentials({
    required this.encryptedUsername,
    required this.encryptedToken,
    required this.pin,
    required this.workspace,
    required this.pronoteBaseUrl,
    required super.deviceUuid,
    super.navIdentifier,
  });

  static Future<LoginResult> loginFromQrCode(
    String qrCode,
    String pin, {
    String? deviceUuid,
  }) async {
    final parsedQrCode = Map<String, dynamic>.from(jsonDecode(qrCode));

    var pronoteBaseUrl = Uri.parse(parsedQrCode.get<String>('url'));
    final urlPathSegment = pronoteBaseUrl.pathSegments
        .toList()
        .skipWhile((value) => value != 'pronote')
        .skip(1)
        .first;

    final tempWorkspace = Workspace(
      type: WorkspaceType.mobileCommun,
      label: urlPathSegment,
      pathSegment: urlPathSegment,
    );
    pronoteBaseUrl = pronoteBaseUrl.replace(
      pathSegments: [
        ...pronoteBaseUrl.pathSegments.takeWhile((value) => value != 'pronote'),
        'pronote',
      ],
    );

    deviceUuid ??= Credentials.generateDeviceUuid();

    final tempCredentials = QrCodeCredentials(
      encryptedUsername: parsedQrCode.get('login'),
      encryptedToken: parsedQrCode.get('jeton'),
      workspace: tempWorkspace,
      pronoteBaseUrl: pronoteBaseUrl,
      pin: pin,
      deviceUuid: deviceUuid,
    );

    return tempCredentials.login();
  }

  @override
  Future<PronoteSession> createSession() => PronoteSession.init(
    pronoteBaseUrl,
    workspace: workspace,
    cookies: [Cookie('appliMobile', '1')],
  );

  @override
  Future<LoginResult> loginBody(PronoteSession session) async {
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
