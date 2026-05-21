import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

final class Room with VisualIdMixin {
  final String label;
  final String id;

  const Room({required this.label, required this.id});

  @override
  CacheType? get cacheType => .ROOM;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
  }
}

extension AsRoom on MapJsonNavigator {
  Room asRoom() {
    return Room(label: get('L'), id: get('N'));
  }
}
