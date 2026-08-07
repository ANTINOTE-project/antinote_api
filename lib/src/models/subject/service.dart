import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/colors.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';
import 'package:antinote_api/src/models/grades/grade.dart';

final class const Service({
  required final String id,
  required final String name,
  required final int? type,
  required final int? order,
  required final Grade? selfAverage,
  required final Grade? theoreticalMaxGrade,
  required final Grade? defaultTheoreticalMaxGrade,
  required final Grade? classAverage,
  required final Grade? minGrade,
  required final Grade? maxGrade,
  required final int? color,

  required final bool? inGroups,
}) with VisualIdMixin implements Comparable<Service> {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    name: nav.get('L'),
    type: nav.get('G'),
    order: nav.get('ordre'),
    selfAverage: nav.get('moyEleve'),
    theoreticalMaxGrade: nav.get('baremeMoyEleve'),
    defaultTheoreticalMaxGrade: nav.get('baremeMoyEleveParDefaut'),
    classAverage: nav.get('moyClasse'),
    minGrade: nav.get('moyMin'),
    maxGrade: nav.get('moyMax'),
    color: nav.get<String?>('couleur')?.asRGB(),
    inGroups: nav.get('estServiceEnGroupe'),
  );

  @override
  int compareTo(Service other) => name.compareTo(other.name);

  @override
  CacheType? get cacheType => .SERVICE;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name.visualIdData();
    yield type?.byteVisualIdData();
    yield theoreticalMaxGrade?.visualIdData();
    yield defaultTheoreticalMaxGrade?.visualIdData();
    yield color?.colorVisualIdData();
    yield inGroups?.visualIdData();
  }
}
