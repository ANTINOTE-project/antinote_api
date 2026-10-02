import 'dart:typed_data';

import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';
import 'package:antinote_api/src/protos/antinote_api/session.pbenum.dart';

final class const VirtualClassroom({
  required final String id,
  required final Uri url,
  required final String comment,
  required final String linkLabel,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    url: Uri.parse(nav.get('url')),
    comment: nav.get('commentaire'),
    linkLabel: nav.get('libelleLien'),
  );

  @override
  CacheType? get cacheType => .VIRTUAL_CLASSROOM;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield url.toString().visualIdData();
    yield comment.visualIdData();
    yield linkLabel.visualIdData();
  }
}
