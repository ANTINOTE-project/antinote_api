import 'dart:convert';
import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/crypto.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:cryptography_plus/cryptography_plus.dart';

final class const AuthenticationResponse({
  required final Uint8List key,
  required final String? relogToken,
  required final DateTime? lastLogin,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    key: nav.get<String>('cle').fromHex(),
    relogToken: nav.get('jetonConnexionAppliMobile'),
    lastLogin: nav.get('derniereConnexion'),
  );

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
