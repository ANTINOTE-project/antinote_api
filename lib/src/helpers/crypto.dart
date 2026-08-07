import 'dart:typed_data';

import 'package:antinote_api/src/protos/antinote/session.pb.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:pointycastle/export.dart' hide Mac;

final rsaModulo1024 = BigInt.parse(
  'B99B77A3D72D3A29B4271FC7B7300E2F791EB8948174BE7B8024667E915446D4EEA0C2424B8D1EBF7E2DDFF94691C6E994E839225C627D140A8F1146D1B0B5F18A09BBD3D8F421CA1E3E4796B301EEBCCF80D81A32A1580121B8294433C38377083C5517D5921E8A078CDC019B15775292EFDA2C30251B1CCABE812386C893E5',
  radix: 16,
);

final rsaExponent1024 = BigInt.parse(
  '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001',
  radix: 16,
);

enum IvMode { real, zeros }

class Crypto {
  Crypto({
    required Uint8List aesIv,
    required this.rsaModulus,
    required this.rsaExponent,
  }) {
    this.aesIv = aesIv;
    _aesKey = Uint8List(0);
  }

  static Future<Crypto> restore(SerializedCrypto serialized) async {
    final crypto = Crypto(
      aesIv: Uint8List.fromList(serialized.iv),
      rsaModulus: serialized.hasRsaModulus()
          ? BigInt.parse(serialized.rsaModulus, radix: 36)
          : rsaModulo1024,
      rsaExponent: serialized.hasRsaExponent()
          ? BigInt.parse(serialized.rsaExponent, radix: 36)
          : rsaExponent1024,
    );

    await crypto.setAesKey(Uint8List.fromList(serialized.key));

    return crypto;
  }

  SerializedCrypto serialize() {
    return SerializedCrypto(
      iv: _aesIv,
      key: _aesKey,
      rsaModulus: rsaModulus == rsaModulo1024
          ? null
          : rsaModulus.toRadixString(36),
      rsaExponent: rsaExponent == rsaExponent1024
          ? null
          : rsaExponent.toRadixString(36),
    );
  }

  late Uint8List _aesKey;

  Uint8List get aesKey => _aesKey;

  Future<void> setAesKey(Uint8List key) async {
    _aesKey = key;
    _aesWand = await createAesWand(key);
  }

  late Uint8List _aesIv;
  late Uint8List _mdAesIv;

  Uint8List get aesIv => _aesIv;

  set aesIv(Uint8List value) {
    _aesIv = value;
    _mdAesIv = Uint8List.fromList(md5.convert(value).bytes);
  }

  BigInt rsaModulus;
  BigInt rsaExponent;

  static final _aesAlgorithm = AesCbc.with128bits(
    macAlgorithm: MacAlgorithm.empty,
  );

  late CipherWand _aesWand;

  Future<CipherWand> createAesWand(Uint8List key) async {
    return _aesAlgorithm.newCipherWandFromSecretKey(
      SecretKey(md5.convert(key).bytes),
    );
  }

  Future<Uint8List> aesEncrypt(
    Uint8List data, {
    IvMode ivMode = IvMode.real,
    CipherWand? auxiliaryWand,
  }) async {
    return Uint8List.fromList(
      (await (auxiliaryWand ?? _aesWand).encrypt(
        data,
        nonce: ivMode == IvMode.real ? _mdAesIv : Uint8List(16),
      )).cipherText,
    );
  }

  Future<Uint8List> aesDecrypt(
    Uint8List data, {
    IvMode ivMode = IvMode.real,
    CipherWand? auxiliaryWand,
  }) async {
    return Uint8List.fromList(
      (await (auxiliaryWand ?? _aesWand).decrypt(
        SecretBox(
          data,
          nonce: ivMode == IvMode.real ? _mdAesIv : Uint8List(16),
          mac: Mac.empty,
        ),
      )),
    );
  }

  PKCS1Encoding _createRsaEngine() {
    // RSAES-PKCS1-V1_5
    final engine = PKCS1Encoding(RSAEngine());

    engine.init(
      true,
      PublicKeyParameter<RSAPublicKey>(RSAPublicKey(rsaModulus, rsaExponent)),
    );

    return engine;
  }

  Uint8List rsaEncrypt(Uint8List data) {
    return _createRsaEngine().process(data);
  }
}

extension FromHex on String {
  Uint8List fromHex() {
    final bytes = Uint8List(length ~/ 2);
    for (int i = 0; i < length; i += 2) {
      bytes[i >> 1] = int.parse(substring(i, i + 2), radix: 16);
    }
    return bytes;
  }
}

extension ToHex on List<int> {
  String toHex() => map((e) => e.toRadixString(16).padLeft(2, '0')).join();
}
