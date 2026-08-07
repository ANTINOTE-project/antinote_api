import 'dart:convert';
import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/enum_id.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';
import 'package:antinote_api/src/models/classes/group.dart';
import 'package:antinote_api/src/models/classes/room.dart';
import 'package:antinote_api/src/models/person.dart';
import 'package:antinote_api/src/models/resource.dart';
import 'package:antinote_api/src/models/subject/subject.dart';
import 'package:antinote_api/src/models/user/resource.dart';

sealed class const ClassContent<T>({
  required final T value,
  required final VisualNavigatorCallback? navigate,
}) with VisualIdMixin {
  static ClassContent decode(
    Map<String, dynamic> nav,
    VisualNavigatorCallback navigate,
  ) {
    return switch (ResourceType.values.byId(
      nav.get('G'),
      defaultValue: .aucune,
    )) {
      .aucune => TitleContent(
        value: nav.get('L'),
        navigate: navigate,
        isTime: nav.get('estHoraire') ?? false,
      ),
      .matiere => SubjectContent(value: .decode(nav), navigate: navigate),
      .enseignant => TeacherContent(value: .decode(nav), navigate: navigate),
      .personnel => PersonalContent(value: .decode(nav), navigate: navigate),
      .salle => ClassroomContent(value: .decode(nav), navigate: navigate),
      .groupe => ClassGroupContent(value: .decode(nav), navigate: navigate),
      .classe => StudentClassContent(value: .decode(nav), navigate: navigate),
      _ => UnknownContent(value: nav, navigate: navigate),
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
  required super.navigate,
  required final bool isTime,
}) extends ClassContent<String> {
  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield value.visualIdData();
    yield isTime.visualIdData();
  }
}

final class const SubjectContent({
  required super.value,
  required super.navigate,
}) extends ClassContent<Subject> with ValueIdClassContentMixin;

final class const TeacherContent({
  required super.value,
  required super.navigate,
}) extends ClassContent<Person> with ValueIdClassContentMixin;

final class const PersonalContent({
  required super.value,
  required super.navigate,
}) extends ClassContent<Person> with ValueIdClassContentMixin;

final class const ClassroomContent({
  required super.value,
  required super.navigate,
}) extends ClassContent<Classroom> with ValueIdClassContentMixin;

final class const VirtualClassroomContent({
  required super.value,
  required super.navigate,
}) extends ClassContent<Uri> {
  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield value.toString().visualIdData();
  }
}

final class const ClassGroupContent({
  required super.value,
  required super.navigate,
}) extends ClassContent<ClassGroup> with ValueIdClassContentMixin;

final class const StudentClassContent({
  required super.value,
  required super.navigate,
}) extends ClassContent<StudentClass> with ValueIdClassContentMixin;

final class const UnknownContent({
  required super.value,
  required super.navigate,
}) extends ClassContent<Map<String, dynamic>> {
  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield jsonEncode(value).visualIdData();
  }
}
