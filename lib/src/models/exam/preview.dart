import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/colors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/room.dart';
import 'package:antinote/src/models/subject/subject.dart';

final class ExamPreview with VisualIdMixin {
  final String label;
  final String id;
  final int type;
  final Subject subject;
  final int color;
  final DateTime startTime;
  final DateTime endTime;

  final List<Room> rooms;

  const ExamPreview({
    required this.label,
    required this.id,
    required this.type,
    required this.subject,
    required this.color,
    required this.startTime,
    required this.endTime,
    required this.rooms,
  });

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

extension AsExamPreview on MapJsonNavigator {
  ExamPreview asExamPreview() {
    return ExamPreview(
      label: get('L'),
      id: get('N'),
      type: get('G'),
      subject: getM('matiere').asSubject(),
      color: get<String>('couleur').asRGB(),
      startTime: get('dateDebut'),
      endTime: get('dateFin'),
      rooms: getLM('listeSalles').mapL((e) => e.asRoom()),
    );
  }
}
