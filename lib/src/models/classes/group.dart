import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

final class ClassGroup with VisualIdMixin {
  final String label;
  final String? id;

  const ClassGroup({required this.label, required this.id});

  @override
  CacheType? get cacheType => .CLASS_GROUP;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
  }
}

extension AsClassGroup on MapJsonNavigator {
  ClassGroup asClassGroup() {
    return ClassGroup(label: get('L'), id: get('N'));
  }
}
