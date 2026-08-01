import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/protos/antinote/session.pbenum.dart';

final class const Break({
  required final String name,
  required final int daySlot,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) =>
      .new(name: nav.get('L'), daySlot: nav.get('place'));

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name.visualIdData();
    yield daySlot.byteVisualIdData();
  }
}
