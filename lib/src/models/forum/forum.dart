import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

final class PedagogicalForum with VisualIdMixin {
  final String label;
  final String id;

  const PedagogicalForum({required this.label, required this.id});

  @override
  CacheType? get cacheType => .PEDAGOGICAL_FORUM;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
  }
}

extension AsPedagogicalForum on MapJsonNavigator {
  PedagogicalForum asPedagogicalForum() {
    return PedagogicalForum(label: get('L'), id: get('N'));
  }
}
