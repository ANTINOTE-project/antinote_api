part of 'classes.dart';

final class Detention extends Class {
  final String? title;
  final List<Person> personals;
  final List<Person> teachers;
  final List<Classroom> classrooms;

  @override
  String? get status => null;

  @override
  bool get canceled => false;

  const Detention({
    required this.title,
    required this.personals,
    required this.teachers,
    required this.classrooms,
    required super.id,
    required super.backgroundColor,
    required super.startDate,
    required super.endDate,
    required super.blockLength,
    required super.blockSlot,
    required super.notes,
    required super.weekNumber,
  });

  @override
  ClassType get type => ClassType.detention;

  factory Detention.decode(
    ClassMessage classMessage,
    MapJsonNavigator detention,
  ) {
    String? title;

    final List<Person> personals = [];
    final List<Person> teachers = [];
    final List<Classroom> classrooms = [];

    if (detention.has('ListeContenus')) {
      for (final MapJsonNavigator data in detention.getLM('ListeContenus')) {
        final label = data.get<String>('L');

        if (data.get('estHoraire') ?? false) {
          title = label;
        } else if (data.has('G')) {
          switch (data.get<int>('G')) {
            case 3:
              teachers.add(data.asPerson());
              break;
            case 34:
              personals.add(data.asPerson());
              break;
            case 17:
              classrooms.add(data.asClassroom());
              break;
            default:
              throw UnimplementedError();
          }
        }
      }
    }

    return Detention(
      title: title,
      personals: personals,
      teachers: teachers,
      classrooms: classrooms,
      id: classMessage.id,
      backgroundColor: classMessage.backgroundColor,
      startDate: classMessage.startDate,
      endDate: classMessage.endDate,
      blockLength: classMessage.blockLength,
      blockSlot: classMessage.blockSlot,
      notes: classMessage.notes,
      weekNumber: classMessage.weekNumber,
    );
  }

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield title?.visualIdData();
    yield* personals.visualIdForEach();
    yield* teachers.visualIdForEach();
    yield* classrooms.visualIdForEach();
    yield backgroundColor?.colorVisualIdData();
    yield blockLength.byteVisualIdData();
    yield notes?.visualIdData();
  }
}
