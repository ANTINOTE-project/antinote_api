import 'dart:convert';
import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

typedef VisualId = String;

mixin VisualIdMixin {
  Iterable<Uint8List?> collectVisualIdData();

  Digest _hashContents() {
    final results = AccumulatorSink<Digest>();
    final sink = sha256.startChunkedConversion(results);
    for (final part in collectVisualIdData()) {
      if (part != null) {
        sink.add(part);
      }
    }

    sink.close();
    results.close();

    assert(results.events.length == 1);

    return results.events.single;
  }

  VisualId get visualId {
    return base64Encode(_hashContents().bytes);
  }

  VisualId get visualIdUrl {
    return base64UrlEncode(_hashContents().bytes);
  }

  CacheType? get cacheType;

  List<VisualNavigator> get toStore => [];

  bool get sensitive => false;
}

extension EachVisualIdData on Iterable<VisualIdMixin> {
  Iterable<Uint8List?> visualIdForEach() sync* {
    for (final item in this) {
      yield* item.collectVisualIdData();
    }
  }
}

extension Uint8ListVisualId on Uint8List {
  VisualId get visualId {
    return base64Encode(sha256.convert(this).bytes);
  }

  VisualId get urlVisualId {
    return base64UrlEncode(sha256.convert(this).bytes);
  }
}

extension IntVisualIdData on int {
  Uint8List bytesVisualIdData() {
    int c = this;
    List<int> bytes = [];
    while (c > 0) {
      bytes.add(c & 0xff);
      c >>= 8;
    }

    return Uint8List.fromList(bytes);
  }

  Uint8List byteVisualIdData() {
    return Uint8List.fromList([this]);
  }

  Uint8List colorVisualIdData() {
    return Uint8List.fromList([
      (this & 0x00FF0000) >> 16,
      (this & 0x0000FF00) >> 8,
      (this & 0x000000FF),
    ]);
  }
}

extension DoubleVisualIdData on double {
  Uint8List visualIdData() {
    return toString().visualIdData();
  }
}

extension BoolVisualIdData on bool {
  static final _true = Uint8List.fromList(const [1]);
  static final _false = Uint8List.fromList(const [0]);

  Uint8List visualIdData() => this ? _true : _false;
}

extension StringVisualIdData on String {
  Uint8List visualIdData() => utf8.encode(this);
}

extension StringListVisualIdData on Iterable<String> {
  Iterable<Uint8List> visualIdData() => map((e) => e.visualIdData());
}
