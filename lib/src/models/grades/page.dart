import '../../../antinote.dart';

final class LatestGradesPage({
  required final Grade? selfGeneralAverage,
  required final Grade? classGeneralAverage,
  required final Grade? maxGeneralAverage,
  required final Grade? defaultMaxGeneralAverage,
  required final bool withExamDetails,
  required final bool withServiceDetails,
  required final List<Service>? services,
  required final List<Exam> exams,
  required final Period? period,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    selfGeneralAverage: nav.get('moyGenerale'),
    classGeneralAverage: nav.get('moyGeneraleClasse'),
    maxGeneralAverage: nav.get('baremeMoyGenerale'),
    defaultMaxGeneralAverage: nav.get('baremeMoyGeneraleParDefaut'),
    withExamDetails: nav.get('avecDetailDevoir'),
    withServiceDetails: nav.get('avecDetailService'),
    services: nav.mGetLM('listeServices')?.mapL((e) => .decode(e)),
    exams: nav.getLM('listeDevoirs').mapL((e) => .decode(e)),
    period: nav.mGo('page', 'periode').inn((value) => .decode(value)),
  );
}
