import 'package:antinote_api/src/helpers/colors.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/models/grades/grade.dart';
import 'package:antinote_api/src/models/person.dart';
import 'package:antinote_api/src/models/report/appreciation.dart';
import 'package:antinote_api/src/models/report/service_category.dart';
import 'package:antinote_api/src/models/subject/subject.dart';

final class const ReportService({
  required final String name,
  required final String id,
  required final bool active,
  required final bool withSubject,
  required final bool withSubSubject,
  required final bool withAppreciationPerSubService,
  required final bool withAveragePerSubSubject,
  required final bool withTeacherLabelPerSubSubject,
  required final bool withTeacherLabelPerSubSubjectOnSameLine,
  required final bool withSubSubjectLabel,
  required final bool withRegroupementAverage,
  required final List<Person>? teachers,
  required final Subject subject,
  required final int color,
  required final Grade? coefficient,
  required final Grade? studentAverage,
  required final Grade? classAverage,
  required final Grade? lowestAverage,
  required final Grade? highestAverage,
  required final List<ReportAppreciation> appreciations,
  required final PartialServiceCategory? category,
  required final int regroupementRank,
  required final int rankWithinRegroupement,

  required final List<ReportServiceSection> sections,
}) {
  factory decode(
    Map<String, dynamic> nav,
    List<ServiceCategory> categories,
  ) => .new(
    name: nav.get('L'),
    id: nav.get('N'),
    active: nav.get<bool?>('A') ?? true,
    withSubject: nav.get('AvecMatiere'),
    withSubSubject: nav.get('AvecSousMatiere'),
    withAppreciationPerSubService: nav.get('AvecAppreciationParSousService'),
    withAveragePerSubSubject: nav.get('AvecMoyenneSousMatiere'),
    withTeacherLabelPerSubSubject: nav.get('AvecLibelleEnseignantSousMatiere'),
    withTeacherLabelPerSubSubjectOnSameLine: nav.get(
      'AvecLibelleEnseignantMatiereSurMemeLigne',
    ),
    withSubSubjectLabel: nav.get('AvecLibelleSousMatiere'),
    withRegroupementAverage: nav.get('AvecMoyenneRegroupement'),
    teachers: nav.mGetLM('ListeProfesseurs')?.mapL((e) => .decode(e)),
    subject: .decode(nav.getM('Matiere')),
    color: nav.get<String>('couleur').asRGB(),
    coefficient: nav.get('Coefficient'),
    studentAverage: nav.get('MoyenneEleve'),
    classAverage: nav.get('MoyenneClasse'),
    lowestAverage: nav.get('MoyenneInf'),
    highestAverage: nav.get('MoyenneSup'),
    appreciations:
        nav.mGetLM('ListeAppreciations')?.mapL((e) => .decode(e)) ?? [],
    category: nav.mGetM('SurMatiere').inn((value) => .decode(value)),
    regroupementRank: nav.get('OrdreRegroupement'),
    rankWithinRegroupement: nav.get('OrdreDansRegroupement'),
    sections: nav.has('ListeElements')
        ? nav.getLM('ListeElements').mapL((e) => .decode(e, categories))
        : List.of([.decode(nav, categories)], growable: false),
  );
}

final class const ReportServiceSection({
  required final String name,
  required final String id,
  required final bool active,
  required final List<Person>? teachers,
  required final List<ReportAppreciation> appreciations,
  required final ServiceCategory? category,
  required final int regroupementRank,
  required final int rankWithinRegroupement,
}) {
  factory decode(Map<String, dynamic> nav, List<ServiceCategory> categories) {
    final sectionId = nav.mGetM('SurMatiere')?.get('N');

    return .new(
      name: nav.get('L'),
      id: nav.get('N'),
      active: nav.get<bool?>('A') ?? true,
      teachers: nav.mGetLM('ListeProfesseurs')?.mapL((e) => .decode(e)),
      appreciations: nav.getLM('ListeAppreciations').mapL((e) => .decode(e)),
      category: sectionId == null
          ? null
          : categories.firstWhere((element) => element.id == sectionId),
      regroupementRank: nav.get('OrdreRegroupement'),
      rankWithinRegroupement: nav.get('OrdreDansRegroupement'),
    );
  }
}
