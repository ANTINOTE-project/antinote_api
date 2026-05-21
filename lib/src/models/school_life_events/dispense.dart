part of 'school_life_events.dart';

class Dispense extends SchoolLifeEvent {
  final bool justified;
  final Subject subject;
  final String dispenseType;

  const Dispense({
    required super.id,
    required super.start,
    required super.end,
    required this.justified,
    required this.subject,
    required this.dispenseType,
    required super.reasons,
  });

  factory Dispense.decode(
    SchoolLifeEventMessage message,
    MapJsonNavigator nav,
  ) {
    return Dispense(
      id: message.id,
      start: message.start!,
      end: message.end!,
      justified: nav.get('justifie'),
      subject: nav.getM('matiere').asSubject(),
      dispenseType: nav.get('strGenreDispense'),
      reasons: message.reasons,
    );
  }

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
