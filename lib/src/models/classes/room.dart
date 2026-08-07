import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';

final class const Classroom({
  required final String label,
  required final String? id,
  required final int count,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    label: nav.get('L'),
    id: nav.get('N'),
    count: nav.get('nombre') ?? 1,
  );

  @override
  CacheType? get cacheType => .CLASSROOM;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
  }
}
