import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/subject/subject.dart';

final class const Theme({
  required final String label,
  required final String id,
  required final Subject? subject,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    label: nav.get('L'),
    id: nav.get('N'),
    subject: nav.mGetM('Matiere').inn((value) => .decode(value)),
  );

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
    yield* subject?.collectVisualIdData() ?? [];
  }

  @override
  CacheType? get cacheType => .THEME;
}
