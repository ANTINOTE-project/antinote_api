part of 'school_life_events.dart';

final class const Other({
  required final String displayName,
  required super.id,

  required super.start,
  required super.end,
  required final DateTime date,
  required final bool read,
  required final bool withArObservation,
  required final Subject subject,
  required final Map<String, dynamic> demandeur, // TODO: Implement this
  required final String comment,
  required final int observationType,

  required final SchoolLifeEventSection section,
  required super.reasons,
}) extends SchoolLifeEvent {
  factory Other.decode(SchoolLifeEventMessage message, MapJsonNavigator nav) =>
      .new(
        displayName: nav.get('L'),
        id: message.id,
        start: null,
        end: null,
        date: nav.get('date'),
        read: nav.get('estLue'),
        withArObservation: nav.get('avecARObservation'),
        subject: .decode(nav.getM('matiere')),
        demandeur: nav.getM('demandeur'),
        comment: nav.get('commentaire'),
        observationType: nav.get('genreObservation'),
        section: .decode(nav.getM('rubrique')),
        reasons: message.reasons,
      );

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield start?.millisecondsSinceEpoch.bytesVisualIdData();
    yield end?.millisecondsSinceEpoch.bytesVisualIdData();
    yield displayName.visualIdData();
    yield date.millisecondsSinceEpoch.bytesVisualIdData();
    yield withArObservation.visualIdData();
    yield* subject.collectVisualIdData();
    yield comment.visualIdData();
    yield observationType.byteVisualIdData();
    yield* section.collectVisualIdData();
  }
}

final class const SchoolLifeEventSection({
  required final String name,
  required final String id,
  required final int type,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) =>
      .new(name: nav.get('L'), id: nav.get('N'), type: nav.get('G'));

  @override
  CacheType? get cacheType => .SCHOOL_LIFE_EVENT_SECTION;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name.visualIdData();
    yield type.byteVisualIdData();
  }
}
