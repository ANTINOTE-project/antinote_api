part of '../resource.dart';

final class NotebookResourceMCQ extends NotebookResource {
  final MCQExecution mcqExecution;

  const NotebookResourceMCQ({
    required super.id,
    required super.type,
    required this.mcqExecution,
  });

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield type?.byteVisualIdData();
    yield* mcqExecution.collectVisualIdData();
  }
}

extension AsNotebookResourceMCQ on MapJsonNavigator {
  NotebookResourceMCQ asNotebookResourceMCQ(NotebookResourceEntryType type) {
    return NotebookResourceMCQ(
      id: get('N'),
      type: get('G'),
      mcqExecution: asMCQExecution(),
    );
  }
}
