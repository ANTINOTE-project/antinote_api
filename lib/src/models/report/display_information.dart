import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/period.dart';

final class ReportDisplayInformation {
  final bool withAppreciationPerSubService;
  final bool withAbsencesDuration;
  final bool withWeekLessonDuration;
  final bool withCoefficient;
  final bool withExamCount;
  final bool withStudentRanking; // classement
  final bool withStudentPointCount;
  final bool withStudentPointBetween;
  final bool withEvolution;
  final int averagePeriodCount;
  final bool withGeneralAverage;
  final bool withGeneralRanking;
  final bool withStudentAverage;
  final bool withStudentMasteryLevel;
  final bool withProposedAverage;
  final bool withDeliberatedAverage;
  final bool withClassAverage;
  final bool withClassMedian;
  final bool withWorstBestAverages;
  final bool withPeriodAverage;
  final bool withYearlyAverage;
  final int appreciationCount;
  final bool withECTS;
  final bool alignAverageToTheRight;
  final bool withProgramElements;
  final bool withExamComments;
  final bool withExamDates;
  final bool withExamCoefficients;
  final bool withCompleteExams;
  final bool withSubServices;

  final List<dynamic> periodsData;

  final List<Period> periodLabels;
  final List<Period> abbreviatedPeriods;

  final List<dynamic> appreciationLabelsData;

  const ReportDisplayInformation({
    required this.withAppreciationPerSubService,
    required this.withAbsencesDuration,
    required this.withWeekLessonDuration,
    required this.withCoefficient,
    required this.withExamCount,
    required this.withStudentRanking,
    required this.withStudentPointCount,
    required this.withStudentPointBetween,
    required this.withEvolution,
    required this.averagePeriodCount,
    required this.withGeneralAverage,
    required this.withGeneralRanking,
    required this.withStudentAverage,
    required this.withStudentMasteryLevel,
    required this.withProposedAverage,
    required this.withDeliberatedAverage,
    required this.withClassAverage,
    required this.withClassMedian,
    required this.withWorstBestAverages,
    required this.withPeriodAverage,
    required this.withYearlyAverage,
    required this.appreciationCount,
    required this.withECTS,
    required this.alignAverageToTheRight,
    required this.withProgramElements,
    required this.withExamComments,
    required this.withExamDates,
    required this.withExamCoefficients,
    required this.withCompleteExams,
    required this.withSubServices,
    required this.periodsData,
    required this.periodLabels,
    required this.abbreviatedPeriods,
    required this.appreciationLabelsData,
  });
}

extension AsReportDisplayInformation on MapJsonNavigator {
  ReportDisplayInformation asReportDisplayInformation() {
    return ReportDisplayInformation(
      withAppreciationPerSubService: get('AvecAppreciationParSousService'),
      withAbsencesDuration: get('AvecDureeDesAbsenses'),
      withWeekLessonDuration: get('AvecVolumeHoraire'),
      withCoefficient: get('AvecCoefficient'),
      withExamCount: get('AvecNombreDevoirs'),
      withStudentRanking: get('AvecClassementEleve'),
      withStudentPointCount: get('AvecNombrePointsEleve'),
      withStudentPointBetween: get('AvecNombrePointsEntre'),
      withEvolution: get('AvecEvolution'),
      averagePeriodCount: get('NombreMoyennesPeriodes'),
      withGeneralAverage: get('AvecMoyenneGenerale'),
      withGeneralRanking: get('AvecClassementGeneral'),
      withStudentAverage: get('AvecMoyenneEleve'),
      withStudentMasteryLevel: get('AvecNivMaitriseEleve'),
      withProposedAverage: get('AvecMoyenneProposee'),
      withDeliberatedAverage: get('AvecMoyenneDeliberee'),
      withClassAverage: get('AvecMoyenneClasse'),
      withClassMedian: get('AvecMoyenneMediane'),
      withWorstBestAverages: get('AvecMoyenneInfSup'),
      withPeriodAverage: get('AvecMoyennePeriode'),
      withYearlyAverage: get('AvecMoyenneAnnuelle'),
      appreciationCount: get('NombreAppreciations'),
      withECTS: get('avecECTS'),
      alignAverageToTheRight: get('alignementMoyADroite'),
      withProgramElements: get('avecElementProgramme'),
      withExamComments: get('avecDevoirsCommentaire'),
      withExamDates: get('avecDevoirsDate'),
      withExamCoefficients: get('avecDevoirsCoefficient'),
      withCompleteExams: get('avecDevoirComplet'),
      withSubServices: get('AvecSousService'),
      periodsData: getL('listePeriodes'),
      periodLabels: getLM('listeLibellesPeriodes').mapL((e) => e.asPeriod()),
      abbreviatedPeriods: getLM(
        'listeAbbreviationsPeriodes',
      ).mapL((e) => e.asPeriod()),
      appreciationLabelsData: getL('ListeIntitulesAppreciations'),
    );
  }
}
