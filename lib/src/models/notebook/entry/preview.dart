import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/notebook/content/category.dart';

final class NotebookEntryPreview with VisualIdMixin {
  final String id;
  final bool isTest;
  final List<NotebookContentCategory> categoryList;

  const NotebookEntryPreview({
    required this.id,
    required this.isTest,
    required this.categoryList,
  });

  @override
  CacheType? get cacheType => .NOTEBOOK_ENTRY_PREVIEW;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield isTest.visualIdData();
    yield* categoryList.visualIdForEach();
  }

  @override
  List<VisualIdMixin> get toStore => categoryList;
}

extension AsNotebookEntryPreview on MapJsonNavigator {
  NotebookEntryPreview asNotebookEntryPreview() {
    return NotebookEntryPreview(
      id: get('N'),
      isTest: get('estDevoir') ?? false,
      categoryList: getLM(
        'originesCategorie',
      ).mapL((e) => e.mAsNotebookContentCategory()!),
    );
  }
}
