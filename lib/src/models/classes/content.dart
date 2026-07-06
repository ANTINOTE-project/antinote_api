import 'dart:convert';
import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/classes/group.dart';
import 'package:antinote/src/models/classes/room.dart';
import 'package:antinote/src/models/person.dart';
import 'package:antinote/src/models/subject/subject.dart';
import 'package:antinote/src/models/user/resource.dart';
import 'package:antinote/src/protos/antinote/session.pbenum.dart';

sealed class ClassContent<T> with VisualIdMixin {
  final T value;

  @override
  CacheType? get cacheType => .CLASS_CONTENT;

  const ClassContent({required this.value});
}

mixin ValueIdClassContentMixin<T extends VisualIdMixin> on ClassContent<T> {
  @override
  CacheType? get cacheType => value.cacheType;

  @override
  Iterable<Uint8List?> collectVisualIdData() => value.collectVisualIdData();
}

extension AsLessonContent on MapJsonNavigator {
  ClassContent asLessonContent() => switch (get('G')) {
    0 ||
    null => TitleContent(value: get('L'), isTime: get('estHoraire') ?? false),
    16 => SubjectContent(value: asSubject()),
    3 => TeacherContent(value: asPerson()),
    34 => PersonalContent(value: asPerson()),
    17 => ClassroomContent(value: asClassroom()),
    2 => ClassGroupContent(value: asClassGroup()),
    1 => StudentClassContent(value: asStudentClass()),
    _ => UnknownContent(value: this),
  };
}

final class TitleContent extends ClassContent<String> {
  final bool isTime;

  const TitleContent({required super.value, required this.isTime});

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield value.visualIdData();
    yield isTime.visualIdData();
  }
}

final class SubjectContent extends ClassContent<Subject>
    with ValueIdClassContentMixin {
  const SubjectContent({required super.value});
}

final class TeacherContent extends ClassContent<Person>
    with ValueIdClassContentMixin {
  const TeacherContent({required super.value});
}

final class PersonalContent extends ClassContent<Person>
    with ValueIdClassContentMixin {
  const PersonalContent({required super.value});
}

final class ClassroomContent extends ClassContent<Classroom>
    with ValueIdClassContentMixin {
  const ClassroomContent({required super.value});
}

final class VirtualClassroomContent extends ClassContent<Uri> {
  const VirtualClassroomContent({required super.value});

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield value.toString().visualIdData();
  }
}

final class ClassGroupContent extends ClassContent<ClassGroup>
    with ValueIdClassContentMixin {
  const ClassGroupContent({required super.value});
}

final class StudentClassContent extends ClassContent<StudentClass>
    with ValueIdClassContentMixin {
  const StudentClassContent({required super.value});
}

final class UnknownContent extends ClassContent<MapJsonNavigator> {
  const UnknownContent({required super.value});

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield jsonEncode(value).visualIdData();
  }
}
