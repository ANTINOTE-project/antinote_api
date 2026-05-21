import 'dart:typed_data';

import 'package:antinote/src/helpers/colors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

final class Subject with VisualIdMixin implements Comparable<Subject> {
  final String id;
  final String? name;

  final bool inGroups;

  final int? backgroundColor;
  final int? textColor;

  const Subject({
    required this.id,
    required this.name,
    required this.inGroups,
    required this.backgroundColor,
    required this.textColor,
  });

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

extension AsSubject on MapJsonNavigator {
  Subject asSubject() {
    return Subject(
      id: get('N'),
      name: get('L'),
      inGroups: get('estServiceEnGroupe') ?? false,
      backgroundColor:
          get<String?>('CouleurFond')?.asRGB() ??
          get<String?>('couleur')?.asRGB(),
      textColor: get<String?>('CouleurTexte')?.asRGB(),
    );
  }
}
