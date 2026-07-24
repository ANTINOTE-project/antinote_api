part of '../resource.dart';

final class const NotebookResourceMCQ({
  required super.id,
  required super.type,
  required final MCQExecution mcqExecution,
}) extends NotebookResource {
  factory decode(Map<String, dynamic> nav) =>
      .new(id: nav.get('N'), type: nav.get('G'), mcqExecution: .decode(nav));

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield type?.byteVisualIdData();
    yield* mcqExecution.collectVisualIdData();
  }
}
