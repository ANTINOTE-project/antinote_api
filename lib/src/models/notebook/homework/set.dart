import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';
import 'package:antinote_api/src/models/homework/homework.dart';

final class const NotebookHomeworkSet({required final List<Homework> homeworks})
    with VisualIdMixin {
  factory decode(List<Map<String, dynamic>> nav) =>
      .new(homeworks: nav.mapL((e) => .decode(e)));

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* homeworks.visualIdForEach();
  }

  @override
  List<VisualNavigator> get toStore => [
    for (final (index, homework) in homeworks.indexed)
      .indexed(homework, field: 'ListeTravauxAFaire', index: index),
  ];
}
