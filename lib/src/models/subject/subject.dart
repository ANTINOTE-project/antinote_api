import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/colors.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';

final class const Subject({
  required final String id,
  required final String? name,

  required final bool inGroups,

  required final int? backgroundColor,
  required final int? textColor,
}) with VisualIdMixin implements Comparable<Subject> {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    name: nav.get('L'),
    inGroups: nav.get('estServiceEnGroupe') ?? false,
    backgroundColor:
        nav.get<String?>('CouleurFond')?.asRGB() ??
        nav.get<String?>('couleur')?.asRGB(),
    textColor: nav.get<String?>('CouleurTexte')?.asRGB(),
  );

  @override
  int compareTo(Subject other) => name?.compareTo(other.name ?? '') ?? 0;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name?.visualIdData();
    yield inGroups.visualIdData();
    yield backgroundColor?.colorVisualIdData();
    yield textColor?.colorVisualIdData();
  }

  @override
  CacheType? get cacheType => .SUBJECT;
}
