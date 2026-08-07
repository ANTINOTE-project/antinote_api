import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';
import 'package:antinote_api/src/models/notebook/resource/entry.dart';
import 'package:antinote_api/src/models/subject/subject.dart';

final class const PedagogicalResourceSet({
  required final List<NotebookResourceEntry> entries,
  required final List<Subject> subjects,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) {
    final subjects = nav
        .getLM('listeMatieres')
        .mapL<Subject>((e) => .decode(e));
    return .new(
      entries: nav.getLM('listeRessources').mapL((e) => .decode(e, subjects)),
      subjects: subjects,
    );
  }

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* entries.visualIdForEach();
    yield* subjects.visualIdForEach();
  }

  @override
  List<VisualNavigator> get toStore => [
    for (final (index, entry) in entries.indexed)
      .indexed(entry, field: 'listeRessources', index: index),
    for (final (index, subject) in subjects.indexed)
      .indexed(subject, field: 'listeMatieres', index: index),
  ];
}
