part of 'school_life_events.dart';

final class const Dispense({
  required super.id,
  required super.start,
  required super.end,
  required final bool justified,
  required final Subject subject,
  required final String dispenseType,
  required super.reasons,
}) extends SchoolLifeEvent {
  factory Dispense.decode(
    SchoolLifeEventMessage message,
    MapJsonNavigator nav,
  ) => .new(
    id: message.id,
    start: message.start!,
    end: message.end!,
    justified: nav.get('justifie'),
    subject: .decode(nav.getM('matiere')),
    dispenseType: nav.get('strGenreDispense'),
    reasons: message.reasons,
  );

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield start?.millisecondsSinceEpoch.bytesVisualIdData();
    yield end?.millisecondsSinceEpoch.bytesVisualIdData();
    yield justified.visualIdData();
    yield* subject.collectVisualIdData();
    yield dispenseType.visualIdData();
  }

  @override
  List<VisualIdMixin> get toStore => [subject, ...reasons];
}
