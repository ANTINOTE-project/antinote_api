library;

import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/enum_id.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';
import 'package:antinote_api/src/models/notebook/resource/resource.dart';
import 'package:antinote_api/src/models/subject/subject.dart';
import 'package:antinote_api/src/models/theme.dart';

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

final class const NotebookResourceEntry({
  required final NotebookResourceEntryType type,
  required final NotebookResource entry,
  required final List<String> notationPeriods,
  required final List<Theme> themes,
  required final DateTime dateTime,
  required final Subject subject,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav, List<Subject> subjects) {
    final type = NotebookResourceEntryType.values.byId(nav.get('G') ?? -1);
    final partialSubject = Subject.decode(nav.getM('matiere'));

    return .new(
      type: type,
      entry: .decode(nav.getM('ressource'), type),
      notationPeriods:
          nav
              .mGetLM('listePeriodesNotation')
              ?.mapL((e) => e.get<String>('N')) ??
          List.empty(growable: false),
      themes: nav.getLM('ListeThemes').mapL((e) => .decode(e)),
      dateTime: nav.get('date'),
      subject: subjects.firstWhere(
        (element) => element.id == partialSubject.id,
        orElse: () => partialSubject,
      ),
    );
  }

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
  List<VisualNavigator> get toStore => [
    .go(entry, field: 'ressource'),
    for (final (index, theme) in themes.indexed)
      .indexed(theme, field: 'ListeThemes', index: index),
    .go(subject, field: 'matiere'),
  ];
}
