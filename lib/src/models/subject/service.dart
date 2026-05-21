import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/colors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/grades/grade.dart';

final class Service with VisualIdMixin implements Comparable<Service> {
  final String id;
  final String name;
  final int? type;
  final int? order;
  final Grade? selfAverage;
  final Grade? theoreticalMaxGrade;
  final Grade? defaultTheoreticalMaxGrade;
  final Grade? classAverage;
  final Grade? minGrade;
  final Grade? maxGrade;
  final int? color;

  final bool? inGroups;

  const Service({
    required this.id,
    required this.name,
    required this.type,
    required this.order,
    required this.selfAverage,
    required this.theoreticalMaxGrade,
    required this.defaultTheoreticalMaxGrade,
    required this.classAverage,
    required this.minGrade,
    required this.maxGrade,
    required this.color,
    required this.inGroups,
  });

  @override
  int compareTo(Service other) => name.compareTo(other.name);

  @override
  CacheType? get cacheType => CacheType.SERVICE;

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

extension AsService on MapJsonNavigator {
  Service asService() {
    return Service(
      id: get('N'),
      name: get('L'),
      type: get('G'),
      order: get('ordre'),
      selfAverage: get('moyEleve'),
      theoreticalMaxGrade: get('baremeMoyEleve'),
      defaultTheoreticalMaxGrade: get('baremeMoyEleveParDefaut'),
      classAverage: get('moyClasse'),
      minGrade: get('moyMin'),
      maxGrade: get('moyMax'),
      color: get<String?>('couleur')?.asRGB(),
      inGroups: get('estServiceEnGroupe'),
    );
    // return Service(
    //   id: get('N'),
    //   name: get('L'),
    //   inGroups: get('estServiceEnGroupe') ?? false,
    //   // backgroundColor: get<String?>('CouleurFond')?.asRGB(),
    //   // textColor: get<String?>('CouleurTexte')?.asRGB(),
    // );
  }
}
