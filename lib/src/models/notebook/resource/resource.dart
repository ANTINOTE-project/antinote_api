library;

import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/enum_id.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/attachment.dart';
import 'package:antinote/src/models/mcq/execution.dart';
import 'package:antinote/src/models/notebook/resource/entry.dart';
import 'package:antinote/src/models/resource.dart';

import '../../forum/forum.dart';

part 'type/attachment.dart';
part 'type/mcq.dart';
part 'type/pedagogical_forum.dart';

sealed class NotebookResource with VisualIdMixin {
  final String id;
  final int? type;

  const NotebookResource({required this.id, required this.type});

  @override
  CacheType? get cacheType => .NOTEBOOK_RESOURCE;
}

extension AsNotebookResource on MapJsonNavigator {
  NotebookResource asNotebookResource(NotebookResourceEntryType type) {
    return switch (type) {
      .cloudDocument ||
      .website ||
      .attachedDocument ||
      .submittedWork => asNotebookResourceAttachment(type),
      .mcq => asNotebookResourceMCQ(type),
      .pedagogicalForum => asNotebookResourcePedagogicalForum(),
      _ => throw UnimplementedError(),
    };
  }
}
