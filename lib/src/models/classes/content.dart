import 'dart:convert';
import 'dart:typed_data';

import 'package:antinote/src/helpers/enum_id.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/classes/group.dart';
import 'package:antinote/src/models/classes/room.dart';
import 'package:antinote/src/models/person.dart';
import 'package:antinote/src/models/resource.dart';
import 'package:antinote/src/models/subject/subject.dart';
import 'package:antinote/src/models/user/resource.dart';
import 'package:antinote/src/protos/antinote/session.pbenum.dart';

sealed class const ClassContent<T>({required final T value})
    with VisualIdMixin {
  static ClassContent decode(Map<String, dynamic> nav) {
    return switch (ResourceType.values.byId(
      nav.get('G'),
      defaultValue: .aucune,
    )) {
      .aucune => TitleContent(
        value: nav.get('L'),
        isTime: nav.get('estHoraire') ?? false,
      ),
      .matiere => SubjectContent(value: .decode(nav)),
      .enseignant => TeacherContent(value: .decode(nav)),
      .personnel => PersonalContent(value: .decode(nav)),
      .salle => ClassroomContent(value: .decode(nav)),
      .groupe => ClassGroupContent(value: .decode(nav)),
      .classe => StudentClassContent(value: .decode(nav)),
      _ => UnknownContent(value: nav),
    };
  }

  @override
  CacheType? get cacheType => .CLASS_CONTENT;
}

mixin ValueIdClassContentMixin<T extends VisualIdMixin> on ClassContent<T> {
  @override
  CacheType? get cacheType => value.cacheType;

  @override
  Iterable<Uint8List?> collectVisualIdData() => value.collectVisualIdData();
}

final class const TitleContent({
  required super.value,
  required final bool isTime,
}) extends ClassContent<String> {
  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield value.visualIdData();
    yield isTime.visualIdData();
  }
}

final class const SubjectContent({required super.value})
    extends ClassContent<Subject>
    with ValueIdClassContentMixin;

final class const TeacherContent({required super.value})
    extends ClassContent<Person>
    with ValueIdClassContentMixin;

final class const PersonalContent({required super.value})
    extends ClassContent<Person>
    with ValueIdClassContentMixin;

final class const ClassroomContent({required super.value})
    extends ClassContent<Classroom>
    with ValueIdClassContentMixin;

final class const VirtualClassroomContent({required super.value})
    extends ClassContent<Uri> {
  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield value.toString().visualIdData();
  }
}

final class const ClassGroupContent({required super.value})
    extends ClassContent<ClassGroup>
    with ValueIdClassContentMixin;

final class const StudentClassContent({required super.value})
    extends ClassContent<StudentClass>
    with ValueIdClassContentMixin;

final class const UnknownContent({required super.value})
    extends ClassContent<Map<String, dynamic>> {
  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield jsonEncode(value).visualIdData();
  }
}
