part of 'classes.dart';

final class Lesson extends Class {
  const Lesson({
    required this.classType,
    required this.status,
    required this.canceled,
    required this.exemptedLabel,
    required this.notebookEntryPreview,
    required this.lessonResourceId,
    required this.contents,

    required super.id,
    required super.backgroundColor,
    required super.startDate,
    required super.endDate,
    required super.blockLength,
    required super.blockSlot,
    required super.notes,
    required super.weekNumber,
    required super.studentCountString,
  });

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
        contents.add(data.asLessonContent());
      }
    }

    if (lesson.has('matiere')) {
      contents.add(SubjectContent(value: lesson.getM('matiere').asSubject()));
    }

    if (lesson.get('AvecCdT') == true && lesson.get('cahierDeTextes') != null) {
      lessonResourceId = lesson.go('cahierDeTextes').get('N');
    }

    return Lesson(
      classType: lesson.get('G'),
      status: lesson.get('Statut'),
      canceled: lesson.get('estAnnule') ?? false,
      exemptedLabel: lesson.mGo('dispenseEleve')?.get('L'),
      notebookEntryPreview: lesson
          .mGetM('cahierDeTextes')
          ?.asNotebookEntryPreview(),
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
  ClassType get type => ClassType.lesson;

  final int classType;
  @override
  final String? status;
  @override
  final bool canceled;
  final String? exemptedLabel;
  final NotebookEntryPreview? notebookEntryPreview;
  @override
  final List<ClassContent> contents;

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

  final String? lessonResourceId;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield classType.byteVisualIdData();
    yield status?.visualIdData();
    yield canceled.visualIdData();
    yield exemptedLabel?.visualIdData();
    yield* virtualClassrooms.map((e) => e.toString()).visualIdData();
    yield* personals.visualIdForEach();
    yield* teachers.visualIdForEach();
    yield* classrooms.visualIdForEach();
    yield* groups.visualIdForEach();
    yield* subject?.collectVisualIdData() ?? [];
    yield backgroundColor?.colorVisualIdData();
    yield backgroundColor?.colorVisualIdData();
  }

  @override
  List<VisualIdMixin> get toStore => [?notebookEntryPreview, ?subject];
}
