import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';

final class const ClassGroup({
  required final String label,
  required final String? id,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) =>
      .new(label: nav.get('L'), id: nav.get('N'));

  @override
  CacheType? get cacheType => .CLASS_GROUP;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
  }
}
