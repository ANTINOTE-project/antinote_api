part of 'school_life_events.dart';

final class const Exclusion({
  required super.id,
  required super.start,
  required super.end,
  required final bool linkedToIncident,
  required final DateTime demandDate,
  required final Map<String, dynamic> nature, // TODO: Implement this
  required final String? comment,
  required final String circonstance,
  required final List<dynamic> documentsForCirconstance, // TODO: Implement this
  required final Map<String, dynamic>? decideur, // TODO: Implement this
  required final Map<String, dynamic> demander, // TODO: Implement this
  required final num duration,
  required final Set<int>? accessRestriction,
  required super.reasons,
}) extends SchoolLifeEvent {
  factory Exclusion.decode(
    SchoolLifeEventMessage message,
    MapJsonNavigator nav,
  ) => .new(
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

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield start?.millisecondsSinceEpoch.bytesVisualIdData();
    yield end?.millisecondsSinceEpoch.bytesVisualIdData();
    yield linkedToIncident.visualIdData();
    yield comment?.visualIdData();
    yield circonstance.visualIdData();
    yield duration.toDouble().visualIdData();
    yield accessRestriction?.asDomain().visualIdData();
  }
}
