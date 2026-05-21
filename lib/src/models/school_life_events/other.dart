part of 'school_life_events.dart';

class Other extends SchoolLifeEvent {
  final String displayName;
  final DateTime date;
  final bool read;
  final bool withArObservation;
  final Subject subject;
  final Map<String, dynamic> demandeur; // TODO: Implement this
  final String comment;
  final int observationType;

  final SchoolLifeEventSection section;

  const Other({
    required this.displayName,
    required super.id,
    required super.start,
    required super.end,
    required this.date,
    required this.read,
    required this.withArObservation,
    required this.subject,
    required this.demandeur,
    required this.comment,
    required this.observationType,
    required this.section,
    required super.reasons,
  });

  factory Other.decode(SchoolLifeEventMessage message, MapJsonNavigator nav) {
    return Other(
      displayName: nav.get('L'),
      id: message.id,
      start: null,
      end: null,
      date: nav.get('date'),
      read: nav.get('estLue'),
      withArObservation: nav.get('avecARObservation'),
      subject: nav.getM('matiere').asSubject(),
      demandeur: nav.getM('demandeur'),
      comment: nav.get('commentaire'),
      observationType: nav.get('genreObservation'),
      section: nav.getM('rubrique').asSchoolLifeEventSection(),
      reasons: message.reasons,
    );
  }

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

final class SchoolLifeEventSection with VisualIdMixin {
  final String name;
  final String id;
  final int type;

  const SchoolLifeEventSection({
    required this.name,
    required this.id,
    required this.type,
  });

  @override
  CacheType? get cacheType => .SCHOOL_LIFE_EVENT_SECTION;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name.visualIdData();
    yield type.byteVisualIdData();
  }
}

extension AsSchoolLifeEventSection on MapJsonNavigator {
  SchoolLifeEventSection asSchoolLifeEventSection() {
    return SchoolLifeEventSection(name: get('L'), id: get('N'), type: get('G'));
  }
}
