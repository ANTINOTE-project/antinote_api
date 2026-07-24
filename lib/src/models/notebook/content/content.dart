import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/attachment.dart';
import 'package:antinote/src/models/notebook/content/category.dart';
import 'package:antinote/src/models/theme.dart';

final class const NotebookContent({
  required final String? label,
  required final String id,
  required final String htmlDescription,
  required final NotebookContentCategory? category,
  required final List<Theme> themes,
  required final String notebookThemeLabel,
  required final int educationalPath,
  required final List<Attachment> attachments,
  required final MapJsonNavigator training,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    label: nav.get('L'),
    id: nav.get('N'),
    htmlDescription: nav.get('descriptif'),
    category: .tryDecode(nav.getM('categorie')),
    themes: nav.getLM('ListeThemes').mapL((e) => .decode(e)),
    notebookThemeLabel: nav.get('libelleCBTheme'),
    educationalPath: nav.get('parcoursEducatif'),
    attachments: nav.getLM('ListePieceJointe').mapL((e) => .decode(e)),
    training: nav.getM('training'),
  );

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
