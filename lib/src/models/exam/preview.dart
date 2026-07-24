import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/colors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/room.dart';
import 'package:antinote/src/models/subject/subject.dart';

final class const ExamPreview({
  required final String label,
  required final String id,
  required final int type,
  required final Subject subject,
  required final int color,
  required final DateTime startTime,
  required final DateTime endTime,

  required final List<Room> rooms,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    label: nav.get('L'),
    id: nav.get('N'),
    type: nav.get('G'),
    subject: .decode(nav.getM('matiere')),
    color: nav.get<String>('couleur').asRGB(),
    startTime: nav.get('dateDebut'),
    endTime: nav.get('dateFin'),
    rooms: nav.getLM('listeSalles').mapL((e) => .decode(e)),
  );

  @override
  CacheType? get cacheType => .EXAM_PREVIEW;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
    yield type.byteVisualIdData();
    yield* subject.collectVisualIdData();
    yield color.colorVisualIdData();
    yield startTime.millisecondsSinceEpoch.bytesVisualIdData();
    yield endTime.millisecondsSinceEpoch.bytesVisualIdData();
    yield* rooms.visualIdForEach();
  }
}
