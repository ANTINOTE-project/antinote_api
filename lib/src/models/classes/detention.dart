part of 'classes.dart';

final class const Detention({
  @override required final List<ClassContent> contents,
  required super.id,
  required super.backgroundColor,
  required super.startDate,
  required super.endDate,
  required super.blockLength,
  required super.blockSlot,
  required super.notes,
  required super.weekNumber,
  required super.studentCountString,
}) extends Class {
  factory Detention.decode(
    ClassMessage classMessage,
    MapJsonNavigator detention,
  ) {
    final List<ClassContent> contents = [];

    if (detention.has('ListeContenus')) {
      for (final MapJsonNavigator data in detention.getLM('ListeContenus')) {
        contents.add(ClassContent.decode(data));
      }
    }

    return .new(
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

  @override
  ClassType get type => .detention;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield title?.visualIdData();
    for (final content in contents) {
      yield* content.collectVisualIdData();
    }
    yield backgroundColor?.colorVisualIdData();
    yield startDate.millisecondsSinceEpoch.bytesVisualIdData();
    yield endDate.millisecondsSinceEpoch.bytesVisualIdData();
  }
}
