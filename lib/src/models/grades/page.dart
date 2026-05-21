import '../../../antinote.dart';

final class LatestGradesPage {
  final Grade? selfGeneralAverage;
  final Grade? classGeneralAverage;
  final Grade? maxGeneralAverage;
  final Grade? defaultMaxGeneralAverage;
  final bool withExamDetails;
  final bool withServiceDetails;

  final List<Service>? services;
  final List<Exam> exams;

  final Period? period;

  const LatestGradesPage({
    required this.selfGeneralAverage,
    required this.classGeneralAverage,
    required this.maxGeneralAverage,
    required this.defaultMaxGeneralAverage,
    required this.withExamDetails,
    required this.withServiceDetails,
    required this.services,
    required this.exams,
    required this.period,
  });
}

extension AsLatestGradesPage on MapJsonNavigator {
  LatestGradesPage asLatestGradesPage() {
    return LatestGradesPage(
      selfGeneralAverage: get('moyGenerale'),
      classGeneralAverage: get('moyGeneraleClasse'),
      maxGeneralAverage: get('baremeMoyGenerale'),
      defaultMaxGeneralAverage: get('baremeMoyGeneraleParDefaut'),
      withExamDetails: get('avecDetailDevoir'),
      withServiceDetails: get('avecDetailService'),
      services: mGetLM('listeServices')?.mapL((e) => e.asService()),
      exams: getLM('listeDevoirs').mapL((e) => e.asExam()),
      period: mGo('page', 'periode')?.asPeriod(),
    );
  }
}
