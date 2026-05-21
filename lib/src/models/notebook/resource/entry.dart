library;

import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/enum_id.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/notebook/resource/resource.dart';
import 'package:antinote/src/models/subject/subject.dart';
import 'package:antinote/src/models/theme.dart';

enum NotebookResourceEntryType implements EnumId {
  attachedDocument(0),
  website(1),
  mcq(2),
  subject(3),
  correction(4),
  submittedWork(5),
  kiosk(6),
  cloudDocument(7),
  pedagogicalForum(-1);

  @override
  final int id;

  const NotebookResourceEntryType(this.id);
}

final class NotebookResourceEntry with VisualIdMixin {
  final NotebookResourceEntryType type;
  final NotebookResource entry;
  final List<String> notationPeriods;
  final List<Theme> themes;
  final DateTime dateTime;
  final Subject subject;

  const NotebookResourceEntry({
    required this.type,
    required this.entry,
    required this.notationPeriods,
    required this.themes,
    required this.dateTime,
    required this.subject,
  });

  @override
  CacheType? get cacheType => .NOTEBOOK_RESOURCE_ENTRY;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield type.id.byteVisualIdData();
    yield entry.type?.byteVisualIdData();
    yield* notationPeriods.visualIdData();
    yield* themes.visualIdForEach();
    yield dateTime.millisecondsSinceEpoch.bytesVisualIdData();
    yield* subject.collectVisualIdData();
  }

  @override
  List<VisualIdMixin> get toStore => [entry, ...themes, subject];
}

extension AsNotebookResourceEntry on MapJsonNavigator {
  NotebookResourceEntry asNotebookResourceEntry(List<Subject> subjects) {
    final type = NotebookResourceEntryType.values.byId(get('G') ?? -1);
    final partialSubject = getM('matiere').asSubject();
    return NotebookResourceEntry(
      type: type,
      entry: getM('ressource').asNotebookResource(type),
      notationPeriods:
          mGetLM('listePeriodesNotation')?.mapL((e) => e.get<String>('N')) ??
          List.empty(growable: false),
      themes: getLM('ListeThemes').mapL((e) => e.asTheme()),
      dateTime: get('date'),
      subject: subjects.firstWhere(
        (element) => element.id == partialSubject.id,
        orElse: () => partialSubject,
      ),
    );
  }
}
