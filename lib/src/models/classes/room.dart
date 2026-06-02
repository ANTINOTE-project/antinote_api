import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';

final class Classroom with VisualIdMixin {
  final String label;
  final String? id;
  final int count;

  const Classroom({required this.label, required this.id, required this.count});

  @override
  CacheType? get cacheType => .CLASSROOM;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
  }
}

extension AsClassroom on MapJsonNavigator {
  Classroom asClassroom() {
    return Classroom(label: get('L'), id: get('N'), count: get('nombre') ?? 1);
  }
}
