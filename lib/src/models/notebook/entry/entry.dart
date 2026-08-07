import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/colors.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';
import 'package:antinote_api/src/models/notebook/content/content.dart';
import 'package:antinote_api/src/models/notebook/entry/group.dart';
import 'package:antinote_api/src/models/person.dart';
import 'package:antinote_api/src/models/subject/subject.dart';

final class const NotebookEntry({
  required final String id,
  required final String lessonId,
  required final bool locked,
  required final List<NotebookEntryGroup> groups,
  required final Subject subject,
  required final int backgroundColor,
  required final List<Person> teachers,
  required final DateTime dateTime,
  required final DateTime endDateTime,
  required final DateTime? homeworkDate,
  required final List<NotebookContent> contents,
  required final List<Map<String, dynamic>> cdtProgramElementList,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    lessonId: nav.go('cours').get('N'),
    locked: nav.get('verrouille'),
    groups: nav.getLM('listeGroupes').mapL((e) => .decode(e)),
    subject: .decode(nav.getM('Matiere')),
    backgroundColor: nav.get<String>('CouleurFond').asRGB(),
    teachers: nav.getLM('listeProfesseurs').mapL((e) => .decode(e)),
    dateTime: nav.get('Date'),
    endDateTime: nav.get('DateFin'),
    homeworkDate: nav.get('DateTAF'),
    contents: nav.getLM('listeContenus').mapL((e) => .decode(e)),
    cdtProgramElementList: nav.getLM('listeElementsProgrammeCDT'),
  );

  @override
  CacheType? get cacheType => .NOTEBOOK_ENTRY;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield locked.visualIdData();
  }

  @override
  List<VisualNavigator> get toStore => [
    .go(subject, field: 'Matiere'),
    for (final (index, group) in groups.indexed)
      .indexed(group, field: 'listeGroupes', index: index),
    for (final (index, teacher) in teachers.indexed)
      .indexed(teacher, field: 'listeProfesseurs', index: index),
    for (final (index, content) in contents.indexed)
      .indexed(content, field: 'listeContenus', index: index),
  ];
}
