part of 'school_life_events.dart';

final class const Delay({
  required super.id,
  required super.start,
  required super.end,
  required final DateTime date,
  required final bool settled,
  required final bool justified,
  required final bool isReasonUnknown,
  required final bool justifyByParents,
  required final int durationMinutes,
  required final String justification,
  required super.reasons,
}) extends SchoolLifeEvent {
  factory Delay.decode(
    SchoolLifeEventMessage message,
    Map<String, dynamic> nav,
  ) {
    return Delay(
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
