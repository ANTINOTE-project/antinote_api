import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

final class NotebookEntryGroup with VisualIdMixin {
  final String label;
  final String id;

  const NotebookEntryGroup({required this.label, required this.id});

  @override
  CacheType? get cacheType => .NOTEBOOK_ENTRY_GROUP;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
  }
}

extension AsNotebookEntryGroup on MapJsonNavigator {
  NotebookEntryGroup asNotebookEntryGroup() {
    return NotebookEntryGroup(label: get('L'), id: get('N'));
  }
}
