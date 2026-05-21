part of 'classes.dart';

final class Lesson extends Class {
  const Lesson({
    required this.classType,
    required this.status,
    required this.canceled,
    required this.exemptedLabel,
    required this.notebookEntryPreview,
    required this.virtualClassrooms,
    required this.personals,
    required this.teachers,
    required this.classrooms,
    required this.groups,
    required this.subject,
    required this.lessonResourceId,

    required super.id,
    required super.backgroundColor,
    required super.startDate,
    required super.endDate,
    required super.blockLength,
    required super.blockSlot,
    required super.notes,
    required super.weekNumber,
  });

  factory Lesson.decode(ClassMessage classMessage, MapJsonNavigator lesson) {
    final List<Uri> virtualClassrooms = [];
    final List<Person> teachers = [];
    final List<Person> personals = [];
    final List<Classroom> classrooms = [];
    final List<ClassGroup> groups = [];
    Subject? subject;
    String? lessonResourceId;

    if (lesson.has('listeVisios')) {
      for (final virtualClassroom in lesson.getLM('listeVisios')) {
        virtualClassrooms.add(Uri.parse(virtualClassroom.get('url')));
      }
    }

    if (lesson.has('ListeContenus')) {
      for (final MapJsonNavigator data in lesson.getLM('ListeContenus')) {
        switch (data.get('G')) {
          case 16:
            subject = data.asSubject();
            break;
          case 3:
            teachers.add(data.asPerson());
            break;
          case 34:
            personals.add(data.asPerson());
            break;
          case 17:
            classrooms.add(data.asClassroom());
            break;
          case 2:
            groups.add(data.asClassGroup());
            break;
        }
      }
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
      virtualClassrooms: virtualClassrooms,
      personals: personals,
      teachers: teachers,
      classrooms: classrooms,
      groups: groups,
      subject: subject,
      lessonResourceId: lessonResourceId,
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
  ClassType get type => ClassType.lesson;

  final int classType;
  final String? status;
  final bool canceled;
  final String? exemptedLabel;
  final NotebookEntryPreview? notebookEntryPreview;
  final List<Uri> virtualClassrooms;
  final List<Person> personals;
  final List<Person> teachers;
  final List<Classroom> classrooms;
  final List<ClassGroup> groups;
  final Subject? subject;

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
