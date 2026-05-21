import 'package:antinote/src/helpers/json.dart';

import '../grades/grade.dart';

final class PartialServiceCategory {
  final String name;
  final String id;

  const PartialServiceCategory({required this.name, required this.id});
}

extension AsPartialServiceCategory on MapJsonNavigator {
  PartialServiceCategory asPartialServiceCategory() {
    return PartialServiceCategory(name: get('L'), id: get('N'));
  }
}

final class ServiceCategory extends PartialServiceCategory {
  final String round;
  final Grade classAverage;
  final Grade medianClassAverage;
  final Grade lowestAverage;
  final Grade highestAverage;

  const ServiceCategory({
    required super.name,
    required super.id,
    required this.round,
    required this.classAverage,
    required this.medianClassAverage,
    required this.lowestAverage,
    required this.highestAverage,
  });
}

extension AsServiceCategory on MapJsonNavigator {
  ServiceCategory asServiceCategory() {
    return ServiceCategory(
      name: get('L'),
      id: get('N'),
      round: get('Arrondi'),
      classAverage: get('MoyenneClasse'),
      medianClassAverage: get('MoyenneMediane'),
      lowestAverage: get('MoyenneInf'),
      highestAverage: get('MoyenneSup'),
    );
  }
}
