import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';
import 'package:antinote_api/src/models/grades/grade.dart';
import 'package:antinote_api/src/models/mcq/mcq.dart';
import 'package:antinote_api/src/models/person.dart';
import 'package:antinote_api/src/models/subject/service.dart';
import 'package:antinote_api/src/models/subject/subject.dart';
import 'package:antinote_api/src/models/theme.dart';

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
  required final Service? service,
  required final Subject? subject,
  required final Grade devoirCoefficient,
  required final String publicName,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    type: nav.get('G'),
    mcq: .decode(nav.getM('QCM')),
    themes: nav.getLM('ListeThemes').mapL((e) => .decode(e)),
    fileAvailable: nav.getB('fichierDispo'),
    isInPublication: nav.getB('estEnPublication'),
    publicationStartDateTime: nav.get('dateDebutPublication'),
    publicationEndDateTime: nav.get('dateFinPublication'),
    htmlAssignment: nav.get('consigne'),
    linkedToDevoir: nav.getB('estLieADevoir'),
    linkedToEvaluation: nav.getB('estLieAEvaluation'),
    isHomework: nav.getB('estUnTAF'),
    isActivity: nav.getB('estUneActivite'),
    isDeletable: nav.getB('estSupprimable'),
    isStarted: nav.getB('estDemarre'),
    studentExecutionExists: nav.getB('existeExecutionEleve'),
    isFinished: nav.getB('estFini'),
    closedState: nav.get('etatCloture') ?? 0,
    answeredQuestionCount: nav.get('nbQuestRepondues') ?? 0,
    correctlyAnsweredQuestionCount: nav.get('nbQuestBonnes') ?? 0,
    mcqGrade: nav.get('noteQCM') ?? Grade.defaultUnknownGrade,
    navigationAllowed: nav.getB('autoriserLaNavigation'),
    homogenizeQuestionCountByLevel: nav.getB('homogeneiserNbQuestParNiveau'),
    fixedQuestionSet: nav.getB('jeuQuestionFixe'),
    shuffleQuestionsGlobally: nav.getB('melangerLesQuestionsGlobalement'),
    shuffleQuestionsByLevel: nav.getB('melangerLesQuestionsParNiveau'),
    shuffleAnswers: nav.getB('melangerLesReponses'),
    collectAnswererFeedback: nav.getB('ressentiRepondant'),
    publishCorrection: nav.getB('publierCorrige'),
    tolerateMishaps: nav.getB('tolererFausses'),
    acceptIncomplete: nav.getB('acceptIncomplet'),
    pointsFromPercentage: nav.getB('pointsSelonPourcentage'),
    showGradeResult: nav.getB('afficherResultatNote'),
    showMasteryLevelResult: nav.getB('afficherResultatNiveauMaitrise'),
    correctionDiffusionType: nav.get('modeDiffusionCorrige'),
    submittedQuestionCount: nav.get('nombreQuestionsSoumises'),
    // The duration is in days for some reason.
    mcqMaxDuration: Duration(
      minutes: (nav.get<double>('dureeMaxQCM') * 24 * 60).floor(),
    ),
    maximumTryCount: nav.get('nbMaxTentative'),
    pointsCount: nav.get('nombreDePoints'),
    teachers: nav.getLM('listeProfesseurs').mapL((e) => .decode(e)),
    bringToTwenty: nav.getB('ramenerSur20'),
    service: nav.mGetM('service') == null ? null : .decode(nav.getM('service')),
    subject: nav.mGetM('matiere') == null ? null : .decode(nav.getM('matiere')),
    devoirCoefficient: nav.get('coefficientDevoir') ?? .defaultUnknownGrade,
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
  List<VisualNavigator> get toStore => [
    for (final (index, theme) in themes.indexed)
      .indexed(theme, field: 'ListeThemes', index: index),
    .go(mcq, field: 'QCM'),
    if (service != null) .go(service!, field: 'service'),
    if (subject != null) .go(subject!, field: 'matiere'),
    for (final (index, teacher) in teachers.indexed)
      .indexed(teacher, field: 'listeProfesseurs', index: index),
  ];
}
