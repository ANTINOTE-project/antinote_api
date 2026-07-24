part of 'classes.dart';

final class const Lesson({
  required final int classType,
  @override required final String? status,
  @override required final bool canceled,
  required final String? exemptedLabel,
  required final NotebookEntryPreview? notebookEntryPreview,
  @override required final List<ClassContent> contents,
  required final String? lessonResourceId,

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
  factory Lesson.decode(ClassMessage classMessage, MapJsonNavigator lesson) {
    final List<ClassContent> contents = [];
    String? lessonResourceId;

    if (lesson.has('listeVisios')) {
      for (final virtualClassroom in lesson.getLM('listeVisios')) {
        contents.add(
          VirtualClassroomContent(
            value: Uri.parse(virtualClassroom.get('url')),
          ),
        );
      }
    }

    if (lesson.has('ListeContenus')) {
      for (final MapJsonNavigator data in lesson.getLM('ListeContenus')) {
        contents.add(ClassContent.decode(data));
      }
    }

    if (lesson.has('matiere')) {
      contents.add(SubjectContent(value: .decode(lesson.getM('matiere'))));
    }

    if (lesson.get('AvecCdT') == true && lesson.get('cahierDeTextes') != null) {
      lessonResourceId = lesson.go('cahierDeTextes').get('N');
    }

    return .new(
      classType: lesson.get('G'),
      status: lesson.get('Statut'),
      canceled: lesson.get('estAnnule') ?? false,
      exemptedLabel: lesson.mGo('dispenseEleve')?.get('L'),
      notebookEntryPreview: lesson
          .mGetM('cahierDeTextes')
          .inn((value) => .decode(value)),
      contents: contents,
      lessonResourceId: lessonResourceId,
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
  ClassType get type => .lesson;

  List<Uri> get virtualClassrooms => contents
      .whereType<VirtualClassroomContent>()
      .map((e) => e.value)
      .toList(growable: false);

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

  List<ClassGroup> get groups => contents
      .whereType<ClassGroupContent>()
      .map((e) => e.value)
      .toList(growable: false);

  Subject? get subject =>
      contents.whereType<SubjectContent>().firstOrNull?.value;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield classType.byteVisualIdData();
    yield* subject?.collectVisualIdData() ?? [];
    yield startDate.millisecondsSinceEpoch.bytesVisualIdData();
    yield endDate.millisecondsSinceEpoch.bytesVisualIdData();

    for (final content in contents) {
      yield* content.collectVisualIdData();
    }
  }

  @override
  List<VisualIdMixin> get toStore => [?notebookEntryPreview, ?subject];
}
