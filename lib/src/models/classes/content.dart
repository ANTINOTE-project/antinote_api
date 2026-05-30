import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/classes/group.dart';
import 'package:antinote/src/models/classes/room.dart';
import 'package:antinote/src/models/person.dart';
import 'package:antinote/src/models/subject/subject.dart';

sealed class ClassContent<T> {
  final T value;

  const ClassContent({required this.value});
}

extension AsLessonContent on MapJsonNavigator {
  ClassContent asLessonContent() => switch (get('G')) {
    0 ||
    null => TitleContent(value: get('L'), isTime: get('estHoraire') ?? false),
    6 => SubjectContent(value: asSubject()),
    3 => TeacherContent(value: asPerson()),
    34 => PersonalContent(value: asPerson()),
    17 => ClassroomContent(value: asClassroom()),
    2 => ClassGroupContent(value: asClassGroup()),
    _ => UnknownContent(value: this),
  };
}

final class TitleContent extends ClassContent<String> {
  final bool isTime;

  const TitleContent({required super.value, required this.isTime});
}

final class SubjectContent extends ClassContent<Subject> {
  const SubjectContent({required super.value});
}

final class TeacherContent extends ClassContent<Person> {
  const TeacherContent({required super.value});
}

final class PersonalContent extends ClassContent<Person> {
  const PersonalContent({required super.value});
}

final class ClassroomContent extends ClassContent<Classroom> {
  const ClassroomContent({required super.value});
}

final class VirtualClassroomContent extends ClassContent<Uri> {
  const VirtualClassroomContent({required super.value});
}

final class ClassGroupContent extends ClassContent<ClassGroup> {
  const ClassGroupContent({required super.value});
}

final class UnknownContent extends ClassContent<MapJsonNavigator> {
  const UnknownContent({required super.value});
}
