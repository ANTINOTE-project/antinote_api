import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/notebook/content/category.dart';

final class const NotebookEntryPreview({
  required final String id,
  required final bool isTest,
  required final List<NotebookContentCategory> categoryList,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    isTest: nav.get('estDevoir') ?? false,
    categoryList: nav.getLM('originesCategorie').mapL((e) => .decode(e)),
  );

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
