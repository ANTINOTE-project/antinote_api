import 'dart:convert';
import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/crypto.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography_plus/cryptography_plus.dart';

final class const Challenge({
  required final Uint8List rawEncryptedChallenge,
  required final bool compatibilityLogin,
  required final bool compatibilityPassword,
  required final String? username,
  required final Uint8List alea,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    rawEncryptedChallenge: nav.get<String>('challenge').fromHex(),
    compatibilityLogin: nav.get<int?>('modeCompLog') == 1,
    compatibilityPassword: nav.get<int?>('modeCompMdp') == 1,
    username: nav.get('login'),
    alea: utf8.encode(nav.get('alea') ?? ''),
  );

  @override
  CacheType? get cacheType => .UNIQUE;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield "Challenge".visualIdData();
  }

  Future<CipherWand> createWand({
    required String cLog,
    required String cMod,
    required Crypto crypto,
    bool addUsernameToWand = true,
  }) {
    final log = compatibilityLogin ? cLog.toLowerCase() : cLog;
    final mod = compatibilityPassword ? cMod.toLowerCase() : cMod;

    final results = AccumulatorSink<Digest>();
    final converter = sha256.startChunkedConversion(results);
    converter.add(alea);
    converter.add(utf8.encode(mod));
    converter.close();

    final key = utf8.encode(
      (addUsernameToWand ? log : '') +
          results.events.single.toString().toUpperCase(),
    );

    return crypto.createAesWand(key);
  }

  Future<Uint8List?> solve({
    required CipherWand challengeWand,
    required Crypto crypto,
  }) async {
    final Uint8List rawChallenge;
    try {
      rawChallenge = await crypto.aesDecrypt(
        rawEncryptedChallenge,
        auxiliaryWand: challengeWand,
      );
    } on Exception {
      // Login failed
      return null;
    }

    final challenge = utf8.decode(rawChallenge, allowMalformed: true);
    final unscrambled = List<int>.filled(challenge.length ~/ 2, 0);

    for (int i = 0; i < challenge.length; i++) {
      if (i % 2 == 0) {
        unscrambled[i ~/ 2] = challenge.codeUnitAt(i);
      }
    }

    return await crypto.aesEncrypt(
      utf8.encode(unscrambled.map((e) => String.fromCharCode(e)).join()),
      auxiliaryWand: challengeWand,
    );
  }
}
