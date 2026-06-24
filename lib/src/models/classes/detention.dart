part of 'classes.dart';

final class Detention extends Class {
  @override
  final List<ClassContent> contents;

  String? get title => contents.whereType<TitleContent>().firstOrNull?.value;

  List<Person> get personals => contents
      .whereType<PersonalContent>()
      .map((e) => e.value)
      .toList(growable: false);

  List<Person> get teachers => contents
      .whereType<TeacherContent>()
      .map((e) => e.value)
      .toList(growable: false);

  List<Classroom> get classrooms => contents
      .whereType<ClassroomContent>()
      .map((e) => e.value)
      .toList(growable: false);

  @override
  String? get status => null;

  @override
  bool get canceled => false;

  const Detention({
    required super.id,
    required super.backgroundColor,
    required super.startDate,
    required super.endDate,
    required super.blockLength,
    required super.blockSlot,
    required super.notes,
    required super.weekNumber,
    required super.studentCountString,
    required this.contents,
  });

  @override
  ClassType get type => ClassType.detention;

  factory Detention.decode(
    ClassMessage classMessage,
    MapJsonNavigator detention,
  ) {
    final List<ClassContent> contents = [];

    if (detention.has('ListeContenus')) {
      for (final MapJsonNavigator data in detention.getLM('ListeContenus')) {
        contents.add(data.asLessonContent());
      }
    }

    return Detention(
      contents: contents,
      id: classMessage.id,
      backgroundColor: classMessage.backgroundColor,
      startDate: classMessage.startDate,
      endDate: classMessage.endDate,
      blockLength: classMessage.blockLength,
      blockSlot: classMessage.blockSlot,
      notes: classMessage.notes,
      weekNumber: classMessage.weekNumber,
      studentCountString: classMessage.studentCountString,
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
