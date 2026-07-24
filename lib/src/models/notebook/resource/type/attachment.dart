part of '../resource.dart';

final class NotebookResourceAttachment({
  required super.id,
  required super.type,
  required final Attachment attachment,
}) extends NotebookResource {
  factory decode(Map<String, dynamic> nav, NotebookResourceEntryType type) {
    assert(
      <ResourceType>[
        .relationTravailAFaireEleve,
        .documentJoint,
        .documentCasier,
      ].contains(ResourceType.values.byId(nav.get<int>('G'))),
      'Unexpected resource type of ${nav.get('G')}',
    );

    return .new(
      id: nav.get('N'),
      type: nav.get('G'),
      attachment: Attachment.decodeResource(type, nav),
    );
  }

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield type?.byteVisualIdData();
    yield* attachment.collectVisualIdData();
  }
}
