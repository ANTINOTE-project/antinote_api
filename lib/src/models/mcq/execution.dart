import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/grades/grade.dart';
import 'package:antinote/src/models/mcq/mcq.dart';
import 'package:antinote/src/models/person.dart';
import 'package:antinote/src/models/subject/service.dart';
import 'package:antinote/src/models/theme.dart';

final class MCQExecution with VisualIdMixin {
  final String id;
  final int type;
  final MCQ mcq;
  final List<Theme> themes;
  final bool fileAvailable;
  final bool isInPublication;
  final DateTime publicationStartDateTime;
  final DateTime publicationEndDateTime;
  final String htmlAssignment;
  final bool linkedToDevoir;
  final bool linkedToEvaluation;
  final bool isHomework;
  final bool isActivity;
  final bool isDeletable;
  final bool isStarted;
  final bool studentExecutionExists;
  final bool isFinished;
  final int closedState;
  final int answeredQuestionCount;
  final int correctlyAnsweredQuestionCount;
  final Grade mcqGrade;
  final bool navigationAllowed;
  final bool homogenizeQuestionCountByLevel;
  final bool fixedQuestionSet;
  final bool shuffleQuestionsGlobally;
  final bool shuffleQuestionsByLevel;
  final bool shuffleAnswers;
  final bool collectAnswererFeedback;
  final bool publishCorrection;
  final bool tolerateMishaps;
  final bool acceptIncomplete;
  final bool pointsFromPercentage;
  final bool showGradeResult;
  final bool showMasteryLevelResult;
  final int correctionDiffusionType;
  final int submittedQuestionCount;
  final Duration mcqMaxDuration;
  final int maximumTryCount;
  final int pointsCount;
  final List<Person> teachers;
  final bool bringToTwenty;
  final Service service;
  final Grade devoirCoefficient;
  final String publicName;

  const MCQExecution({
    required this.id,
    required this.type,
    required this.mcq,
    required this.themes,
    required this.fileAvailable,
    required this.isInPublication,
    required this.publicationStartDateTime,
    required this.publicationEndDateTime,
    required this.htmlAssignment,
    required this.linkedToDevoir,
    required this.linkedToEvaluation,
    required this.isHomework,
    required this.isActivity,
    required this.isDeletable,
    required this.isStarted,
    required this.studentExecutionExists,
    required this.isFinished,
    required this.closedState,
    required this.answeredQuestionCount,
    required this.correctlyAnsweredQuestionCount,
    required this.mcqGrade,
    required this.navigationAllowed,
    required this.homogenizeQuestionCountByLevel,
    required this.fixedQuestionSet,
    required this.shuffleQuestionsGlobally,
    required this.shuffleQuestionsByLevel,
    required this.shuffleAnswers,
    required this.collectAnswererFeedback,
    required this.publishCorrection,
    required this.tolerateMishaps,
    required this.acceptIncomplete,
    required this.pointsFromPercentage,
    required this.showGradeResult,
    required this.showMasteryLevelResult,
    required this.correctionDiffusionType,
    required this.submittedQuestionCount,
    required this.mcqMaxDuration,
    required this.maximumTryCount,
    required this.pointsCount,
    required this.teachers,
    required this.bringToTwenty,
    required this.service,
    required this.devoirCoefficient,
    required this.publicName,
  });

  @override
  CacheType? get cacheType => .MCQ_EXECUTION;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    // TODO: Complete this.
    yield type.byteVisualIdData();
    yield* themes.visualIdForEach();
    yield publicationStartDateTime.millisecondsSinceEpoch.bytesVisualIdData();
    yield publicationEndDateTime.millisecondsSinceEpoch.bytesVisualIdData();
    yield htmlAssignment.visualIdData();
  }

  @override
  List<VisualIdMixin> get toStore => [...themes, mcq, service, ...teachers];
}

extension AsMCQExecution on MapJsonNavigator {
  MCQExecution asMCQExecution() {
    return MCQExecution(
      id: get('N'),
      type: get('G'),
      mcq: getM('QCM').asMCQ(),
      themes: getLM('ListeThemes').mapL((e) => e.asTheme()),
      fileAvailable: get('fichierDispo'),
      isInPublication: get('estEnPublication'),
      publicationStartDateTime: get('dateDebutPublication'),
      publicationEndDateTime: get('dateFinPublication'),
      htmlAssignment: get('consigne'),
      linkedToDevoir: get('estLieADevoir'),
      linkedToEvaluation: get('estLieAEvaluation'),
      isHomework: get('estUnTAF'),
      isActivity: get('estUneActivite'),
      isDeletable: get('estSupprimable'),
      isStarted: get('estDemarre'),
      studentExecutionExists: get('existeExecutionEleve'),
      isFinished: get('estFini'),
      closedState: get('etatCloture'),
      answeredQuestionCount: get('nbQuestRepondues'),
      correctlyAnsweredQuestionCount: get('nbQuestBonnes'),
      mcqGrade: get('noteQCM'),
      navigationAllowed: get('autoriserLaNavigation'),
      homogenizeQuestionCountByLevel: get('homogeneiserNbQuestParNiveau'),
      fixedQuestionSet: get('jeuQuestionFixe'),
      shuffleQuestionsGlobally: get('melangerLesQuestionsGlobalement'),
      shuffleQuestionsByLevel: get('melangerLesQuestionsParNiveau'),
      shuffleAnswers: get('melangerLesReponses'),
      collectAnswererFeedback: get('ressentiRepondant'),
      publishCorrection: get('publierCorrige'),
      tolerateMishaps: get('tolererFausses'),
      acceptIncomplete: get('acceptIncomplet'),
      pointsFromPercentage: get('pointsSelonPourcentage'),
      showGradeResult: get('afficherResultatNote'),
      showMasteryLevelResult: get('afficherResultatNiveauMaitrise'),
      correctionDiffusionType: get('modeDiffusionCorrige'),
      submittedQuestionCount: get('nombreQuestionsSoumises'),
      // The duration is in days for some reason.
      mcqMaxDuration: Duration(
        minutes: (get<double>('dureeMaxQCM') * 24 * 60).floor(),
      ),
      maximumTryCount: get('nbMaxTentative'),
      pointsCount: get('nombreDePoints'),
      teachers: getLM('listeProfesseurs').mapL((e) => e.asPerson()),
      bringToTwenty: get('ramenerSur20'),
      service: getM('service').asService(),
      devoirCoefficient: get('coefficientDevoir'),
      publicName: get('nomPublic'),
    );
  }
}
