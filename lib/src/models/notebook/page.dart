import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/notebook/entry/entry.dart';
import 'package:antinote/src/models/notebook/homework/set.dart';
import 'package:antinote/src/models/notebook/resource/set.dart';

final class const NotebookPage({
  required final List<NotebookEntry> entries,
  required final PedagogicalResourceSet? resourceSet,
  required final Map<String, dynamic>? numericResourceSet,
  required final NotebookHomeworkSet? homeworkSet,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    entries:
        nav.mGetLM('ListeCahierDeTextes')?.mapL((e) => .decode(e)) ??
        List.empty(growable: false),
    resourceSet: nav
        .mGetM('ListeRessourcesPedagogiques')
        .inn((value) => .decode(value)),
    numericResourceSet: nav.mGetM('ListeRessourcesNumeriques'),
    homeworkSet: nav
        .mGetLM('ListeTravauxAFaire')
        .inn((value) => .decode(value)),
  );

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    // /*
    //
    //     ...result.entries,
    //     ...?result.homeworkSet?.homeworks,
    //     ...?result.resourceSet?.entries,*/

    yield* entries.visualIdForEach();
    yield* resourceSet?.collectVisualIdData() ?? [];
    yield* homeworkSet?.collectVisualIdData() ?? [];
  }

  @override
  List<VisualNavigator> get toStore => [
    for (final (index, entry) in entries.indexed)
      .indexed(entry, field: 'ListeCahierDeTextes', index: index),
    if (resourceSet != null)
      .go(resourceSet!, field: 'ListeRessourcesPedagogiques'),
    if (homeworkSet != null) .stay(homeworkSet!),
  ];
}
