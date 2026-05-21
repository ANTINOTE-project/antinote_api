part of 'school_life_events.dart';

class Absence extends SchoolLifeEvent {
  final bool open;
  final bool settled;
  final bool justified;
  final bool isReasonUnknown;
  final bool justifyByParents;
  final String hourCount;
  final double dayCount;

  const Absence({
    required super.id,
    required super.start,
    required super.end,
    required this.open,
    required this.settled,
    required this.justified,
    required this.isReasonUnknown,
    required this.justifyByParents,
    required this.hourCount,
    required this.dayCount,
    required super.reasons,
  });

  factory Absence.decode(SchoolLifeEventMessage message, MapJsonNavigator nav) {
    return Absence(
      id: message.id,
      start: message.start!,
      end: message.end!,
      open: nav.get('ouverte'),
      settled: nav.get('reglee'),
      justified: nav.get('justifie'),
      isReasonUnknown: nav.get('estMotifNonEncoreConnu'),
      justifyByParents: nav.get('aJustifierParParents'),
      hourCount: nav.get('NbrHeures'),
      dayCount: nav.get('NbrJours'),
      reasons: message.reasons,
    );
  }

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield start?.millisecondsSinceEpoch.bytesVisualIdData();
    yield end?.millisecondsSinceEpoch.bytesVisualIdData();
    yield open.visualIdData();
    yield settled.visualIdData();
    yield justified.visualIdData();
    yield isReasonUnknown.visualIdData();
    yield justifyByParents.visualIdData();
    yield hourCount.visualIdData();
    yield dayCount.visualIdData();
  }

  @override
  List<VisualIdMixin> get toStore => [...reasons];
}
