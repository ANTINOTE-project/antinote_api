import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/colors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/notebook/content/content.dart';
import 'package:antinote/src/models/notebook/entry/group.dart';
import 'package:antinote/src/models/person.dart';
import 'package:antinote/src/models/subject/subject.dart';

final class NotebookEntry with VisualIdMixin {
  final String id;
  final String lessonId;
  final bool locked;
  final List<NotebookEntryGroup> groupList;
  final Subject subject;
  final int backgroundColor;
  final List<Person> teacherList;
  final DateTime dateTime;
  final DateTime endDateTime;
  final DateTime? homeworkDate;
  final List<NotebookContent> contentList;
  final ListJsonNavigator<MapJsonNavigator> cdtProgramElementList;

  const NotebookEntry({
    required this.id,
    required this.lessonId,
    required this.locked,
    required this.groupList,
    required this.subject,
    required this.backgroundColor,
    required this.teacherList,
    required this.dateTime,
    required this.endDateTime,
    required this.homeworkDate,
    required this.contentList,
    required this.cdtProgramElementList,
  });

  @override
  CacheType? get cacheType => .NOTEBOOK_ENTRY;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield locked.visualIdData();
  }

  @override
  List<VisualIdMixin> get toStore => [
    subject,
    ...groupList,
    ...teacherList,
    ...contentList,
  ];
}

extension AsNotebookEntry on MapJsonNavigator {
  NotebookEntry asNotebookEntry() {
    return NotebookEntry(
      id: get('N'),
      lessonId: go('cours').get('N'),
      locked: get('verrouille'),
      groupList: getLM('listeGroupes').mapL((e) => e.asNotebookEntryGroup()),
      subject: getM('Matiere').asSubject(),
      backgroundColor: get<String>('CouleurFond').asRGB(),
      teacherList: getLM('listeProfesseurs').mapL((e) => e.asPerson()),
      dateTime: get('Date'),
      endDateTime: get('DateFin'),
      homeworkDate: get('DateTAF'),
      contentList: getLM('listeContenus').mapL((e) => e.asNotebookContent()),
      cdtProgramElementList: getLM('listeElementsProgrammeCDT'),
    );
  }
}
