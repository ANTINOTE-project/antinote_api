import 'package:antinote/src/helpers/colors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/grades/grade.dart';
import 'package:antinote/src/models/person.dart';
import 'package:antinote/src/models/report/appreciation.dart';
import 'package:antinote/src/models/report/service_category.dart';
import 'package:antinote/src/models/subject/subject.dart';

final class ReportService {
  final String name;
  final String id;
  final bool A; // TODO: Find out what this is.
  final bool withSubject;
  final bool withSubSubject;
  final bool withAppreciationPerSubService;
  final bool withAveragePerSubSubject;
  final bool withTeacherLabelPerSubSubject;
  final bool withTeacherLabelPerSubSubjectOnSameLine;
  final bool withSubSubjectLabel;
  final bool withRegroupementAverage;
  final List<Person>? teachers;
  final Subject subject;
  final int color;
  final Grade? coefficient;
  final Grade? studentAverage;
  final Grade? classAverage;
  final Grade? lowestAverage;
  final Grade? highestAverage;
  final List<ReportAppreciation> appreciations;
  final PartialServiceCategory? category;
  final int regroupementRank;
  final int rankWithinRegroupement;

  final List<ReportServiceSection> sections;

  const ReportService({
    required this.name,
    required this.id,
    required this.A,
    required this.withSubject,
    required this.withSubSubject,
    required this.withAppreciationPerSubService,
    required this.withAveragePerSubSubject,
    required this.withTeacherLabelPerSubSubject,
    required this.withTeacherLabelPerSubSubjectOnSameLine,
    required this.withSubSubjectLabel,
    required this.withRegroupementAverage,
    required this.teachers,
    required this.subject,
    required this.color,
    required this.coefficient,
    required this.studentAverage,
    required this.classAverage,
    required this.lowestAverage,
    required this.highestAverage,
    required this.appreciations,
    required this.category,
    required this.regroupementRank,
    required this.rankWithinRegroupement,
    required this.sections,
  });
}

extension AsReportService on MapJsonNavigator {
  ReportService asReportService(List<ServiceCategory> categories) {
    return ReportService(
      name: get('L'),
      id: get('N'),
      A: get('A'),
      withSubject: get('AvecMatiere'),
      withSubSubject: get('AvecSousMatiere'),
      withAppreciationPerSubService: get('AvecAppreciationParSousService'),
      withAveragePerSubSubject: get('AvecMoyenneSousMatiere'),
      withTeacherLabelPerSubSubject: get('AvecLibelleEnseignantSousMatiere'),
      withTeacherLabelPerSubSubjectOnSameLine: get(
        'AvecLibelleEnseignantMatiereSurMemeLigne',
      ),
      withSubSubjectLabel: get('AvecLibelleSousMatiere'),
      withRegroupementAverage: get('AvecMoyenneRegroupement'),
      teachers: mGetLM('ListeProfesseurs')?.mapL((e) => e.asPerson()),
      subject: getM('Matiere').asSubject(),
      color: get<String>('couleur').asRGB(),
      coefficient: get('Coefficient'),
      studentAverage: get('MoyenneEleve'),
      classAverage: get('MoyenneClasse'),
      lowestAverage: get('MoyenneInf'),
      highestAverage: get('MoyenneSup'),
      appreciations:
          mGetLM('ListeAppreciations')?.mapL((e) => e.asReportAppreciation()) ??
          [],
      category: getM('SurMatiere')?.asPartialServiceCategory(),
      regroupementRank: get('OrdreRegroupement'),
      rankWithinRegroupement: get('OrdreDansRegroupement'),
      sections: has('ListeElements')
          ? getLM(
              'ListeElements',
            ).mapL((e) => e.asReportServiceSection(categories))
          : List.of([asReportServiceSection(categories)], growable: false),
    );
  }
}

final class ReportServiceSection {
  final String name;
  final String id;
  final bool A; // TODO: Find out what this is.
  final List<Person>? teachers;
  final List<ReportAppreciation> appreciations;
  final ServiceCategory? category;
  final int regroupementRank;
  final int rankWithinRegroupement;

  const ReportServiceSection({
    required this.name,
    required this.id,
    required this.A,
    required this.teachers,
    required this.appreciations,
    required this.category,
    required this.regroupementRank,
    required this.rankWithinRegroupement,
  });
}

extension AsReportServiceSection on MapJsonNavigator {
  ReportServiceSection asReportServiceSection(
    List<ServiceCategory> categories,
  ) {
    final sectionId = mGetM('SurMatiere')?.get('N');

    return ReportServiceSection(
      name: get('L'),
      id: get('N'),
      A: get('A'),
      teachers: mGetLM('ListeProfesseurs')?.mapL((e) => e.asPerson()),
      appreciations: getLM(
        'ListeAppreciations',
      ).mapL((e) => e.asReportAppreciation()),
      category: sectionId == null
          ? null
          : categories.firstWhere((element) => element.id == sectionId),
      regroupementRank: get('OrdreRegroupement'),
      rankWithinRegroupement: get('OrdreDansRegroupement'),
    );
  }
}
