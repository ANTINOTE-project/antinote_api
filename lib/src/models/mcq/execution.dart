import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/grades/grade.dart';
import 'package:antinote/src/models/mcq/mcq.dart';
import 'package:antinote/src/models/person.dart';
import 'package:antinote/src/models/subject/service.dart';
import 'package:antinote/src/models/theme.dart';

final class const MCQExecution({
  required final String id,
  required final int type,
  required final MCQ mcq,
  required final List<Theme> themes,
  required final bool fileAvailable,
  required final bool isInPublication,
  required final DateTime publicationStartDateTime,
  required final DateTime publicationEndDateTime,
  required final String htmlAssignment,
  required final bool linkedToDevoir,
  required final bool linkedToEvaluation,
  required final bool isHomework,
  required final bool isActivity,
  required final bool isDeletable,
  required final bool isStarted,
  required final bool studentExecutionExists,
  required final bool isFinished,
  required final int closedState,
  required final int answeredQuestionCount,
  required final int correctlyAnsweredQuestionCount,
  required final Grade mcqGrade,
  required final bool navigationAllowed,
  required final bool homogenizeQuestionCountByLevel,
  required final bool fixedQuestionSet,
  required final bool shuffleQuestionsGlobally,
  required final bool shuffleQuestionsByLevel,
  required final bool shuffleAnswers,
  required final bool collectAnswererFeedback,
  required final bool publishCorrection,
  required final bool tolerateMishaps,
  required final bool acceptIncomplete,
  required final bool pointsFromPercentage,
  required final bool showGradeResult,
  required final bool showMasteryLevelResult,
  required final int correctionDiffusionType,
  required final int submittedQuestionCount,
  required final Duration mcqMaxDuration,
  required final int maximumTryCount,
  required final int pointsCount,
  required final List<Person> teachers,
  required final bool bringToTwenty,
  required final Service service,
  required final Grade devoirCoefficient,
  required final String publicName,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    type: nav.get('G'),
    mcq: .decode(nav.getM('QCM')),
    themes: nav.getLM('ListeThemes').mapL((e) => .decode(e)),
    fileAvailable: nav.get('fichierDispo'),
    isInPublication: nav.get('estEnPublication'),
    publicationStartDateTime: nav.get('dateDebutPublication'),
    publicationEndDateTime: nav.get('dateFinPublication'),
    htmlAssignment: nav.get('consigne'),
    linkedToDevoir: nav.get('estLieADevoir'),
    linkedToEvaluation: nav.get('estLieAEvaluation'),
    isHomework: nav.get('estUnTAF'),
    isActivity: nav.get('estUneActivite'),
    isDeletable: nav.get('estSupprimable'),
    isStarted: nav.get('estDemarre'),
    studentExecutionExists: nav.get('existeExecutionEleve'),
    isFinished: nav.get('estFini'),
    closedState: nav.get('etatCloture'),
    answeredQuestionCount: nav.get('nbQuestRepondues'),
    correctlyAnsweredQuestionCount: nav.get('nbQuestBonnes'),
    mcqGrade: nav.get('noteQCM'),
    navigationAllowed: nav.get('autoriserLaNavigation'),
    homogenizeQuestionCountByLevel: nav.get('homogeneiserNbQuestParNiveau'),
    fixedQuestionSet: nav.get('jeuQuestionFixe'),
    shuffleQuestionsGlobally: nav.get('melangerLesQuestionsGlobalement'),
    shuffleQuestionsByLevel: nav.get('melangerLesQuestionsParNiveau'),
    shuffleAnswers: nav.get('melangerLesReponses'),
    collectAnswererFeedback: nav.get('ressentiRepondant'),
    publishCorrection: nav.get('publierCorrige'),
    tolerateMishaps: nav.get('tolererFausses'),
    acceptIncomplete: nav.get('acceptIncomplet'),
    pointsFromPercentage: nav.get('pointsSelonPourcentage'),
    showGradeResult: nav.get('afficherResultatNote'),
    showMasteryLevelResult: nav.get('afficherResultatNiveauMaitrise'),
    correctionDiffusionType: nav.get('modeDiffusionCorrige'),
    submittedQuestionCount: nav.get('nombreQuestionsSoumises'),
    // The duration is in days for some reason.
    mcqMaxDuration: Duration(
      minutes: (nav.get<double>('dureeMaxQCM') * 24 * 60).floor(),
    ),
    maximumTryCount: nav.get('nbMaxTentative'),
    pointsCount: nav.get('nombreDePoints'),
    teachers: nav.getLM('listeProfesseurs').mapL((e) => .decode(e)),
    bringToTwenty: nav.get('ramenerSur20'),
    service: .decode(nav.getM('service')),
    devoirCoefficient: nav.get('coefficientDevoir'),
    publicName: nav.get('nomPublic'),
  );

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
