part of '../resource.dart';

final class NotebookResourceAttachment extends NotebookResource {
  final Attachment attachment;

  const NotebookResourceAttachment({
    required super.id,
    required super.type,
    required this.attachment,
  });

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield type?.byteVisualIdData();
    yield* attachment.collectVisualIdData();
  }
}

extension AsNotebookResourceAttachment on MapJsonNavigator {
  NotebookResourceAttachment asNotebookResourceAttachment(
    NotebookResourceEntryType type,
  ) {
    assert(
      <ResourceType>[
        .relationTravailAFaireEleve,
        .documentJoint,
        .documentCasier,
      ].contains(ResourceType.values.byId(get<int>('G'))),
      'Unexpected resource type of ${get('G')}',
    );
    return NotebookResourceAttachment(
      id: get('N'),
      type: get('G'),
      attachment: Attachment.decodeResource(type, this),
    );
  }
}
