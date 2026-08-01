import 'dart:typed_data';

import 'package:antinote/antinote.dart';

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
}) with VisualIdMixin {
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

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield* period?.collectVisualIdData() ?? [];
    yield* services?.visualIdForEach() ?? [];
    yield* exams.visualIdForEach();
  }

  @override
  List<VisualNavigator> get toStore => [
    if (period != null)
      .new(exchanger: (nav) => nav.go('page', 'periode'), value: period!),
    if (services != null)
      for (final (index, service) in services!.indexed)
        .indexed(service, field: 'listeServices', index: index),
    for (final (index, exam) in exams.indexed)
      .new(
        exchanger: (nav) => nav.getLM('listeDevoirs').get(index),
        value: exam,
      ),
  ];
}
