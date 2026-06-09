part of 'school_life_events.dart';

class Exclusion extends SchoolLifeEvent {
  final bool linkedToIncident;
  final DateTime demandDate;
  final Map<String, dynamic> nature; // TODO: Implement this
  final String? comment;
  final String circonstance;
  final List<dynamic> documentsForCirconstance; // TODO: Implement this
  final Map<String, dynamic>? decideur; // TODO: Implement this
  final Map<String, dynamic> demander; // TODO: Implement this
  final int duration;
  final Set<int> accessRestriction;

  const Exclusion({
    required super.id,
    required super.start,
    required super.end,
    required this.linkedToIncident,
    required this.demandDate,
    required this.nature,
    required this.comment,
    required this.circonstance,
    required this.documentsForCirconstance,
    required this.decideur,
    required this.demander,
    required this.duration,
    required this.accessRestriction,
    required super.reasons,
  });

  factory Exclusion.decode(
    SchoolLifeEventMessage message,
    MapJsonNavigator nav,
  ) {
    return Exclusion(
      id: message.id,
      start: message.start,
      end: message.end,
      linkedToIncident: nav.get('estLieAUnIncident'),
      demandDate: nav.get('dateDemande'),
      nature: nav.get('nature'),
      comment: nav.eGet(['commentaire']),
      circonstance: nav.get('circonstances'),
      documentsForCirconstance: nav.getL('documentsCirconstances'),
      decideur: nav.mGetM('decideur'),
      demander: nav.getM('demandeur'),
      duration: nav.get('duree'),
      accessRestriction: nav.get('interditAcces'),
      reasons: message.reasons,
    );
  }

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield start?.millisecondsSinceEpoch.bytesVisualIdData();
    yield end?.millisecondsSinceEpoch.bytesVisualIdData();
    yield linkedToIncident.visualIdData();
    yield comment?.visualIdData();
    yield circonstance.visualIdData();
    yield duration.toString().visualIdData();
    yield accessRestriction.asDomain().visualIdData();
  }
}
