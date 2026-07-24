import 'package:antinote/src/helpers/json.dart';

import '../grades/grade.dart';

final class const PartialServiceCategory({
  required final String name,
  required final String id,
}) {
  factory decode(Map<String, dynamic> nav) =>
      .new(name: nav.get('L'), id: nav.get('N'));
}

final class const ServiceCategory({
  required super.name,
  required super.id,
  required final String round,
  required final Grade classAverage,
  required final Grade medianClassAverage,
  required final Grade lowestAverage,
  required final Grade highestAverage,
}) extends PartialServiceCategory {
  factory decode(Map<String, dynamic> nav) => .new(
    name: nav.get('L'),
    id: nav.get('N'),
    round: nav.get('Arrondi'),
    classAverage: nav.get('MoyenneClasse'),
    medianClassAverage: nav.get('MoyenneMediane'),
    lowestAverage: nav.get('MoyenneInf'),
    highestAverage: nav.get('MoyenneSup'),
  );
}
