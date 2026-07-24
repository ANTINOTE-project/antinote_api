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

sealed class const NotebookResource({
  required final String id,
  required final int? type,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav, NotebookResourceEntryType type) =>
      switch (type) {
        .cloudDocument ||
        .website ||
        .attachedDocument ||
        .submittedWork => NotebookResourceAttachment.decode(nav, type),
        .mcq => NotebookResourceMCQ.decode(nav),
        .pedagogicalForum => NotebookResourcePedagogicalForum.decode(nav),
        _ => throw UnimplementedError(),
      };

  @override
  CacheType? get cacheType => .NOTEBOOK_RESOURCE;
}
