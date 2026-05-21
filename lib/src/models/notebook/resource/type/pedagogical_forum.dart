part of '../resource.dart';

final class NotebookResourcePedagogicalForum extends NotebookResource {
  final PedagogicalForum forum;

  const NotebookResourcePedagogicalForum({
    required super.id,
    required super.type,
    required this.forum,
  });

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield type?.byteVisualIdData();
    yield* forum.collectVisualIdData();
  }
}

extension AsNotebookResourcePedagogicalForum on MapJsonNavigator {
  NotebookResourcePedagogicalForum asNotebookResourcePedagogicalForum() {
    return NotebookResourcePedagogicalForum(
      id: get('N'),
      type: get('G'),
      forum: asPedagogicalForum(),
    );
  }
}

// multipart/form-data; boundary=----geckoformboundary2d532e8abfe4da9f1534f75570736f32
