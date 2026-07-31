part of 'school_life_events.dart';

final class const Absence({
  required super.id,
  required super.start,
  required super.end,
  required final bool open,
  required final bool settled,
  required final bool justified,
  required final bool isReasonUnknown,
  required final bool justifyByParents,
  required final String hourCount,
  required final double dayCount,
  required super.reasons,
}) extends SchoolLifeEvent {
  factory Absence.decode(
    SchoolLifeEventMessage message,
    Map<String, dynamic> nav,
  ) => .new(
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
