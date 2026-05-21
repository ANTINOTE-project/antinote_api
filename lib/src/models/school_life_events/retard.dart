part of 'school_life_events.dart';

class Retard extends SchoolLifeEvent {
  final DateTime date;
  final bool settled;
  final bool justified;
  final bool isReasonUnknown;
  final bool justifyByParents;
  final int durationMinutes;
  final String justification;

  const Retard({
    required super.id,
    required super.start,
    required super.end,
    required this.date,
    required this.settled,
    required this.justified,
    required this.isReasonUnknown,
    required this.justifyByParents,
    required this.durationMinutes,
    required this.justification,
    required super.reasons,
  });

  factory Retard.decode(SchoolLifeEventMessage message, MapJsonNavigator nav) {
    return Retard(
      id: message.id,
      start: null,
      end: null,
      date: nav.get('date'),
      settled: nav.get('reglee'),
      justified: nav.get('justifie'),
      isReasonUnknown: nav.get('estMotifNonEncoreConnu'),
      justifyByParents: nav.get('aJustifierParParents'),
      durationMinutes: nav.get('duree'),
      justification: nav.get('justification'),
      reasons: message.reasons,
    );
  }

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield start?.millisecondsSinceEpoch.bytesVisualIdData();
    yield end?.millisecondsSinceEpoch.bytesVisualIdData();
    yield date.millisecondsSinceEpoch.bytesVisualIdData();
    yield settled.visualIdData();
    yield justified.visualIdData();
    yield isReasonUnknown.visualIdData();
    yield justifyByParents.visualIdData();
    yield durationMinutes.bytesVisualIdData();
    yield justification.visualIdData();
  }
}
