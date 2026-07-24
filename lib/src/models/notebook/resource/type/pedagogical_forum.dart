part of '../resource.dart';

final class const NotebookResourcePedagogicalForum({
  required super.id,
  required super.type,
  required final PedagogicalForum forum,
}) extends NotebookResource {
  factory decode(Map<String, dynamic> nav) =>
      .new(id: nav.get('N'), type: nav.get('G'), forum: .decode(nav));

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield type?.byteVisualIdData();
    yield* forum.collectVisualIdData();
  }
}
