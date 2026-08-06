import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/period.dart';

final class const ReportDisplayInformation({
  required final bool withAppreciationPerSubService,
  required final bool withAbsencesDuration,
  required final bool withWeekLessonDuration,
  required final bool withCoefficient,
  required final bool withExamCount,
  required final bool withStudentRanking, // classement
  required final bool withStudentPointCount,
  required final bool withStudentPointBetween,
  required final bool withEvolution,
  required final int averagePeriodCount,
  required final bool withGeneralAverage,
  required final bool withGeneralRanking,
  required final bool withStudentAverage,
  required final bool withStudentMasteryLevel,
  required final bool withProposedAverage,
  required final bool withDeliberatedAverage,
  required final bool withClassAverage,
  required final bool withClassMedian,
  required final bool withWorstBestAverages,
  required final bool withPeriodAverage,
  required final bool withYearlyAverage,
  required final int appreciationCount,
  required final bool withECTS,
  required final bool alignAverageToTheRight,
  required final bool withProgramElements,
  required final bool withExamComments,
  required final bool withExamDates,
  required final bool withExamCoefficients,
  required final bool withCompleteExams,
  required final bool withSubServices,

  required final List<dynamic> periodsData,

  required final List<Period> periodLabels,
  required final List<Period> abbreviatedPeriods,

  required final List<AppreciationLabel> appreciationLabels,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    withAppreciationPerSubService: nav.getB('AvecAppreciationParSousService'),
    withAbsencesDuration: nav.getB('AvecDureeDesAbsenses'),
    withWeekLessonDuration: nav.getB('AvecVolumeHoraire'),
    withCoefficient: nav.getB('AvecCoefficient'),
    withExamCount: nav.getB('AvecNombreDevoirs'),
    withStudentRanking: nav.getB('AvecClassementEleve'),
    withStudentPointCount: nav.getB('AvecNombrePointsEleve'),
    withStudentPointBetween: nav.getB('AvecNombrePointsEntre'),
    withEvolution: nav.getB('AvecEvolution'),
    averagePeriodCount: nav.get('NombreMoyennesPeriodes'),
    withGeneralAverage: nav.getB('AvecMoyenneGenerale'),
    withGeneralRanking: nav.getB('AvecClassementGeneral'),
    withStudentAverage: nav.getB('AvecMoyenneEleve'),
    withStudentMasteryLevel: nav.getB('AvecNivMaitriseEleve'),
    withProposedAverage: nav.getB('AvecMoyenneProposee'),
    withDeliberatedAverage: nav.getB('AvecMoyenneDeliberee'),
    withClassAverage: nav.getB('AvecMoyenneClasse'),
    withClassMedian: nav.getB('AvecMoyenneMediane'),
    withWorstBestAverages: nav.getB('AvecMoyenneInfSup'),
    withPeriodAverage: nav.getB('AvecMoyennePeriode'),
    withYearlyAverage: nav.getB('AvecMoyenneAnnuelle'),
    appreciationCount: nav.get('NombreAppreciations'),
    withECTS: nav.getB('avecECTS'),
    alignAverageToTheRight: nav.getB('alignementMoyADroite'),
    withProgramElements: nav.getB('avecElementProgramme'),
    withExamComments: nav.getB('avecDevoirsCommentaire'),
    withExamDates: nav.getB('avecDevoirsDate'),
    withExamCoefficients: nav.getB('avecDevoirsCoefficient'),
    withCompleteExams: nav.getB('avecDevoirComplet'),
    withSubServices: nav.getB('AvecSousService'),
    periodsData: nav.getL('listePeriodes'),
    periodLabels: nav.getLM('listeLibellesPeriodes').mapL((e) => .decode(e)),
    abbreviatedPeriods: nav
        .getLM('listeAbbreviationsPeriodes')
        .mapL((e) => .decode(e)),
    appreciationLabels: nav
        .getLM('ListeIntitulesAppreciations')
        .mapL((e) => .decode(e)),
  );
}

final class const AppreciationLabel({
  required final int type,
  required final String label,
}) {
  factory decode(Map<String, dynamic> nav) =>
      .new(type: nav.get('G'), label: nav.get('L'));
}
