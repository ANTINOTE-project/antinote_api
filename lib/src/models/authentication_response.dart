import 'dart:convert';
import 'dart:typed_data';

import 'package:antinote/src/helpers/crypto.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';
import 'package:cryptography_plus/cryptography_plus.dart';

class AuthenticationResponse with VisualIdMixin {
  final Uint8List key;
  final String? relogToken;
  final DateTime? lastLogin;

  const AuthenticationResponse({
    required this.key,
    required this.relogToken,
    required this.lastLogin,
  });

  Future<Uint8List> toAuthKey(Crypto crypto, CipherWand challengeWand) async {
    return Uint8List.fromList(
      utf8
          .decode(await crypto.aesDecrypt(key, auxiliaryWand: challengeWand))
          .split(',')
          .mapL(int.parse),
    );
  }

  @override
  CacheType? get cacheType => .UNIQUE;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield "AuthenticationResponse".visualIdData();
  }
}

extension AsAuthenticationResponse on MapJsonNavigator {
  AuthenticationResponse asAuthenticationResponse() {
    return AuthenticationResponse(
      key: get<String>('cle').fromHex(),
      relogToken: get('jetonConnexionAppliMobile'),
      lastLogin: get('derniereConnexion'),
    );
  }
}
