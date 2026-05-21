import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/attachment.dart';
import 'package:antinote/src/models/notebook/content/category.dart';
import 'package:antinote/src/models/theme.dart';

final class NotebookContent with VisualIdMixin {
  final String? label;
  final String id;
  final String htmlDescription;
  final NotebookContentCategory? category;
  final List<Theme> themes;
  final String notebookThemeLabel;
  final int educationalPath;
  final List<Attachment> attachments;
  final MapJsonNavigator training;

  const NotebookContent({
    required this.label,
    required this.id,
    required this.htmlDescription,
    required this.category,
    required this.themes,
    required this.notebookThemeLabel,
    required this.educationalPath,
    required this.attachments,
    required this.training,
  });

  @override
  CacheType? get cacheType => .NOTEBOOK_CONTENT;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label?.visualIdData();
    yield htmlDescription.visualIdData();
    yield* category?.collectVisualIdData() ?? [];
    yield* themes.visualIdForEach();
    yield notebookThemeLabel.visualIdData();
    yield* attachments.visualIdForEach();
  }

  @override
  List<VisualIdMixin> get toStore => [?category, ...themes, ...attachments];
}

extension AsNotebookContent on MapJsonNavigator {
  NotebookContent asNotebookContent() {
    return NotebookContent(
      label: get('L'),
      id: get('N'),
      htmlDescription: get('descriptif'),
      category: getM('categorie').mAsNotebookContentCategory(),
      themes: getLM('ListeThemes').mapL((e) => e.asTheme()),
      notebookThemeLabel: get('libelleCBTheme'),
      educationalPath: get('parcoursEducatif'),
      attachments: getLM('ListePieceJointe').mapL((e) => e.asAttachment()),
      training: getM('training'),
    );
  }
}
