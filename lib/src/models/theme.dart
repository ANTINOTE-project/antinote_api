import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/subject/subject.dart';

final class Theme with VisualIdMixin {
  const Theme({required this.label, required this.id, required this.subject});

  final String label;
  final String id;
  final Subject? subject;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label.visualIdData();
    yield* subject?.collectVisualIdData() ?? [];
  }

  @override
  CacheType? get cacheType => .THEME;
}

extension AsTheme on MapJsonNavigator {
  Theme asTheme() => Theme(
    label: get('L'),
    id: get('N'),
    subject: mGetM('Matiere')?.asSubject(),
  );
}
