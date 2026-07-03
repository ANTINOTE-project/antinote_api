part of 'shared.dart';

final class SpecificInstanceParameters extends InstanceParameters {
  final DateTime serverDateTime;
  final DateTime? demoDateTime;
  final Workspace workspace;
  final bool hostedInFrance;
  final bool withForum;
  final Uri? helpUrl;
  final Uri? videosAccessUrl;
  final Uri? twitterAccessUrl;
  final Uri? doubleAuthRegistrationFAQUrl;
  final Uri? securityVideoTutorialUrl;
  final Uri? devicesRegisterTutorialUrl;
  final Uri? canopeUrl;
  final bool withConnexionChoice;
  final int firstWeekNumber;
  final DateTime firstCycleStartDate;
  final DateTime firstMonday;
  final DateTime firstDate;
  final DateTime lastDate;
  final int slotsPerDay;
  final int slotsPerHour;
  final double sequenceLength;
  final int halfDayAbsenceSlot;
  final int typeAbsencesViaDJ;
  final bool defaultPresenceExemptionValue;
  final bool lunchActivation;
  final int lunchStartSlot;
  final int lunchEndSlot;
  final bool fullHoursAfterNoon;
  final DateTime nextBusinessDay;
  final List<int> businessDays;
  final Set<int> lunchDays;
  final bool discussionBetweenParentsActivated;
  final bool excellenceParcoursGestion;
  final bool blogActivation;
  final int businessDaysPerCycle;
  final int firstWeekday;
  final int scheduleGridInCycle;
  final Set<int> businessCycleDays;
  final List<Set<int>> businessHalfDays;
  final Map<int, WeekFrequency> weekFrequencies;
  final Map<WeekFrequency, int?> weekFrequenciesPeriodicity;
  final Map<WeekFrequency, WeekFrequency?> followingFrequencies;
  final Grade bareme;
  final Grade maxBareme;
  final int defaultPublicationInterval;
  final int publicationIntervalForParents;
  final bool withGradesPublicationIntervalDisplayToParents;
  final bool withTestsPublicationIntervalDisplayToParents;
  final Set<int> allowedAnnotations;

  // TODO: Create models this. (ListeNiveauxDAcquisitions)
  final List<Map<String, dynamic>> acquirementLevels;
  final bool showShorthandForAcquirementLevel;
  final bool withHistoricalTests;
  final bool withoutIntermediaryLevelValidationExamInAutomaticValidation;
  final bool onlyCountExamsForSchoolYearInAutomaticValidation;
  final bool ponderateSubjectsRelativeToTheirCoefficientDomain;
  final bool cecrlLevelManagement;
  final int langActivityColor;
  final int minimumBaremeForMCQQuestion;
  final int maximumBaremeForMCQQuestion;
  final int maxPointsForMCQ;
  final int maxLevelForMCQ;
  final int skillGridElementLabelSize;
  final int homeworkCommentSize;
  final bool withConnexionInformationRetrieval;
  final bool? parentAuthorisesPasswordChange;
  final String? font;
  final int? fontSize;
  final bool withAttachedStudents;
  final String phoneMask;
  final int ectsMaximum;
  final List<int> appreciationMaxSize;
  final List<Holiday> holidays;
  final bool showSequences;
  final List<TimeSlot> starts;
  final List<TimeSlot> endings;
  final List<TimeSlot> endingsForSL;
  final List<String> sequences;
  final List<Period> periods;
  final List<Pause> pauses;
  final int audioRecordingHomeworkSubmissionMaxSize;
  final Set<int> validHomeworkSubmissionTypes;
  final String applicationCookieName;

  // TODO: Create a model for this. (aideContextuelle)
  final Map<String, dynamic> contextualHelp;

  SpecificInstanceParameters({
    required super.shared,
    required this.serverDateTime,
    required this.demoDateTime,
    required this.workspace,
    required this.hostedInFrance,
    required this.withForum,
    required this.helpUrl,
    required this.videosAccessUrl,
    required this.twitterAccessUrl,
    required this.doubleAuthRegistrationFAQUrl,
    required this.securityVideoTutorialUrl,
    required this.devicesRegisterTutorialUrl,
    required this.canopeUrl,
    required this.withConnexionChoice,
    required this.firstWeekNumber,
    required this.firstCycleStartDate,
    required this.firstMonday,
    required this.firstDate,
    required this.lastDate,
    required this.slotsPerDay,
    required this.slotsPerHour,
    required this.sequenceLength,
    required this.halfDayAbsenceSlot,
    required this.typeAbsencesViaDJ,
    required this.defaultPresenceExemptionValue,
    required this.lunchActivation,
    required this.lunchStartSlot,
    required this.lunchEndSlot,
    required this.fullHoursAfterNoon,
    required this.nextBusinessDay,
    required this.businessDays,
    required this.lunchDays,
    required this.discussionBetweenParentsActivated,
    required this.excellenceParcoursGestion,
    required this.blogActivation,
    required this.businessDaysPerCycle,
    required this.firstWeekday,
    required this.scheduleGridInCycle,
    required this.businessCycleDays,
    required this.businessHalfDays,
    required this.weekFrequencies,
    required this.weekFrequenciesPeriodicity,
    required this.followingFrequencies,
    required this.bareme,
    required this.maxBareme,
    required this.defaultPublicationInterval,
    required this.publicationIntervalForParents,
    required this.withGradesPublicationIntervalDisplayToParents,
    required this.withTestsPublicationIntervalDisplayToParents,
    required this.allowedAnnotations,
    required this.acquirementLevels,
    required this.showShorthandForAcquirementLevel,
    required this.withHistoricalTests,
    required this.withoutIntermediaryLevelValidationExamInAutomaticValidation,
    required this.onlyCountExamsForSchoolYearInAutomaticValidation,
    required this.ponderateSubjectsRelativeToTheirCoefficientDomain,
    required this.cecrlLevelManagement,
    required this.langActivityColor,
    required this.minimumBaremeForMCQQuestion,
    required this.maximumBaremeForMCQQuestion,
    required this.maxPointsForMCQ,
    required this.maxLevelForMCQ,
    required this.skillGridElementLabelSize,
    required this.homeworkCommentSize,
    required this.withConnexionInformationRetrieval,
    required this.parentAuthorisesPasswordChange,
    required this.font,
    required this.fontSize,
    required this.withAttachedStudents,
    required this.phoneMask,
    required this.ectsMaximum,
    required this.appreciationMaxSize,
    required this.holidays,
    required this.showSequences,
    required this.starts,
    required this.endings,
    required this.endingsForSL,
    required this.sequences,
    required this.periods,
    required this.pauses,
    required this.audioRecordingHomeworkSubmissionMaxSize,
    required this.validHomeworkSubmissionTypes,
    required this.applicationCookieName,
    required this.contextualHelp,
  }) : super.shared();

  int getWeekNumberForDate(DateTime date) =>
      firstWeekNumber +
      ((date.toUtc().millisecondsSinceEpoch -
                  firstMonday.toUtc().millisecondsSinceEpoch) ~/
              (Duration.millisecondsPerSecond *
                  Duration.secondsPerMinute *
                  Duration.minutesPerHour *
                  Duration.hoursPerDay)) ~/
          7;

  DateTime getDateForWeekNumber(int weekNumber) {
    return firstMonday.add(Duration(days: 7 * (weekNumber - firstWeekNumber)));
  }

  DateTime timeForSlot(TimeSlot slot, DateTime day) {
    return day.copyWith(hour: slot.timing.hour, minute: slot.timing.minute);
  }

  int daySlotForTime(DateTime time) {
    for (int i = 0; i < starts.length; i++) {
      if (starts[i] <= time && endings[i] > time) {
        return i;
      }
    }

    return -1;
  }

  bool isBusinessDay(DateTime day) {
    day = day.copyWith(isUtc: true);

    if (!businessDays.contains(day.weekday)) {
      return false;
    }

    if (holidays.any(
      (holiday) =>
          !holiday.startDate.isAfter(day) && !holiday.endDate.isBefore(day),
    )) {
      return false;
    }

    final weekNumber = getWeekNumberForDate(day);

    if (!weekFrequencies.containsKey(weekNumber)) {
      return false;
    }

    return true;
  }

  bool isBusinessHalfDay(DateTime time) {
    if (!isBusinessDay(time.toDay())) return false;

    final slot = daySlotForTime(time);

    if (slot < 0) return false;

    final int halfDay;
    if (slot < lunchStartSlot) {
      halfDay = 0; // Morning
    } else if (slot >= lunchEndSlot) {
      halfDay = 1; // Afternoon
    } else {
      halfDay = 0; // Somewhere in-between, considered morning afaik
    }

    return businessHalfDays[halfDay].contains(time.weekday);
  }

  DateTime findBusinessDay(
    DateTime anchor,
    Duration offset, {
    bool canBeDifferent = false,
  }) {
    final startAnchor = anchor.copyWith();
    while (((offset.isNegative
                ? !anchor.isBefore(firstDate)
                : !anchor.isAfter(lastDate)) &&
            !isBusinessDay(anchor)) ||
        (canBeDifferent ? false : startAnchor.isAtSameMomentAs(anchor))) {
      anchor = anchor.add(offset);
    }

    return anchor;
  }

  List<DateTime> listBusinessDays() {
    List<DateTime> days = [];
    for (
      DateTime date = firstDate.copyWith();
      !date.isAfter(lastDate);
      date = date.add(Duration(days: 1))
    ) {
      if (isBusinessDay(date)) days.add(date);
    }

    return days;
  }

  Period defaultPeriod(DateTime time) {
    for (final period in periods) {
      if (!period.startDate!.isAfter(time) && !period.endDate!.isBefore(time)) {
        return period;
      }
    }

    return periods.first;
  }

  @override
  List<VisualIdMixin> get toStore => [...holidays, ...periods];
}

extension AsSpecificInstanceParameters on MapJsonNavigator {
  (
    Map<int, WeekFrequency>,
    Map<WeekFrequency, int?>,
    Map<WeekFrequency, WeekFrequency?>,
  )
  _buildWeekFrequenciesAndPeriodicity() {
    Map<int, WeekFrequency> weekFrequencies = {};

    for (final fortnight in [1, 2]) {
      final frequency = go(
        'General',
      ).getL('DomainesFrequences').getL<int>(fortnight);
      for (final week in frequency) {
        weekFrequencies[week] = WeekFrequency(
          label: go('General').getL('LibellesFrequences').get(fortnight),
          fortnight: fortnight,
        );
      }
    }

    Map<
      WeekFrequency,
      ({int? periodicity, int lastWeekNumber, bool ignoreNext})
    >
    weekFrequenciesPeriodicity = HashMap();
    final weekFrequenciesEntries = weekFrequencies.entries.toList(
      growable: false,
    );
    weekFrequenciesEntries.sort((a, b) => a.key.compareTo(b.key));
    for (
      int i = weekFrequenciesEntries.first.key;
      i <= weekFrequenciesEntries.last.key;
      i++
    ) {
      final filtered = weekFrequenciesEntries.where(
        (element) => element.key == i,
      );

      if (filtered.isEmpty) {
        weekFrequenciesPeriodicity.updateAll(
          (key, value) => (
            ignoreNext: true,
            lastWeekNumber: value.lastWeekNumber,
            periodicity: value.periodicity,
          ),
        );
        continue;
      }

      final MapEntry(key: weekNumber, value: frequency) = filtered.single;

      if (!weekFrequenciesPeriodicity.containsKey(frequency)) {
        weekFrequenciesPeriodicity[frequency] = (
          periodicity: -1,
          lastWeekNumber: weekNumber,
          ignoreNext: false,
        );
      } else {
        final value = weekFrequenciesPeriodicity[frequency]!;

        final diff = weekNumber - value.lastWeekNumber;
        if (value.periodicity != -1 &&
            diff != value.periodicity &&
            !value.ignoreNext) {
          weekFrequenciesPeriodicity.update(
            frequency,
            (value) => (
              periodicity: null,
              lastWeekNumber: weekNumber,
              ignoreNext: false,
            ),
          );
        }

        weekFrequenciesPeriodicity.update(
          frequency,
          (value) => (
            periodicity: diff,
            lastWeekNumber: weekNumber,
            ignoreNext: false,
          ),
        );
      }
    }

    Map<WeekFrequency, WeekFrequency?> followingFrequencies = HashMap();
    for (final MapEntry(key: weekNumber, value: frequency)
        in weekFrequencies.entries) {
      final followingFrequency = weekFrequencies[weekNumber + 1];
      if (followingFrequency == null) continue;

      if (!followingFrequencies.containsKey(frequency)) {
        followingFrequencies[frequency] = followingFrequency;
      } else {
        final expectedFrequency = followingFrequencies[frequency];
        if (followingFrequency != expectedFrequency) {
          followingFrequencies[frequency] = null;
        }
      }
    }

    return (
      weekFrequencies,
      weekFrequenciesPeriodicity.map(
        (key, value) => MapEntry(key, value.periodicity),
      ),
      followingFrequencies,
    );
  }

  SpecificInstanceParameters asSpecificInstanceParameters(
    SharedInstanceParameters shared,
    Workspace temporaryWorkspace,
  ) {
    final general = getM('General');
    final (frequency, frequencyPeriodicity, followingFrequencies) =
        _buildWeekFrequenciesAndPeriodicity();

    return SpecificInstanceParameters(
      shared: shared,
      serverDateTime: get('DateServeurHttp'),
      demoDateTime: get('DateDemo'),
      workspace: Workspace(
        type: temporaryWorkspace.type,
        label: get('Nom'),
        pathSegment: temporaryWorkspace.pathSegment,
      ),
      hostedInFrance: general.getB('estHebergeEnFrance'),
      withForum: general.getB('avecForum'),
      helpUrl: Uri.tryParse(general.get('UrlAide') ?? ""),
      videosAccessUrl: Uri.tryParse(general.get('urlAccesVideos') ?? ""),
      twitterAccessUrl: Uri.tryParse(general.get('urlAccesTwitter') ?? ""),
      doubleAuthRegistrationFAQUrl: Uri.tryParse(
        general.get('urlFAQEnregistrementDoubleAuth') ?? "",
      ),
      devicesRegisterTutorialUrl: Uri.tryParse(
        general.get('urlTutoEnregistrerAppareils') ?? "",
      ),
      canopeUrl: Uri.tryParse(general.get('urlCanope') ?? ""),
      securityVideoTutorialUrl: Uri.tryParse(
        general.get('urlTutoVideoSecurite') ?? "",
      ),
      withConnexionChoice: general.getB('AvecChoixConnexion'),
      firstWeekNumber: general.get('numeroPremiereSemaine'),
      firstCycleStartDate: general.get('dateDebutPremierCycle'),
      firstMonday: general.get('PremierLundi'),
      firstDate: general.get('PremiereDate'),
      lastDate: general.get('DerniereDate'),
      slotsPerDay: general.get('PlacesParJour'),
      slotsPerHour: general.get('PlacesParHeure'),
      sequenceLength: general.get('DureeSequence'),
      halfDayAbsenceSlot: general.get('PlaceDemiJourneeAbsence'),
      typeAbsencesViaDJ: general.get('saisirAbsencesParDJ'),
      defaultPresenceExemptionValue: general.get(
        'valeurDefautPresenceDispense',
      ),
      lunchActivation: general.getB('activationDemiPension'),
      lunchStartSlot: general.get('debutDemiPension'),
      lunchEndSlot: general.get('finDemiPension'),
      fullHoursAfterNoon: general.getB('AvecHeuresPleinesApresMidi'),
      nextBusinessDay: general.get('JourOuvre'),
      businessDays: general.getL<int>('JoursOuvres'),
      lunchDays: general.get('JoursDemiPension'),
      discussionBetweenParentsActivated: general.getB(
        'ActivationMessagerieEntreParents',
      ),
      excellenceParcoursGestion: general.getB('GestionParcoursExcellence'),
      blogActivation: general.getB('activerBlog'),
      businessDaysPerCycle: general.get('joursOuvresParCycle'),
      firstWeekday: general.get('premierJourSemaine'),
      scheduleGridInCycle: general.get('grillesEDTEnCycle'),
      businessCycleDays: general.get('setOfJoursCycleOuvre'),
      businessHalfDays: general.getL<Set<int>>('DemiJourneesOuvrees'),
      weekFrequencies: frequency,
      weekFrequenciesPeriodicity: frequencyPeriodicity,
      followingFrequencies: followingFrequencies,
      bareme: general.get('BaremeNotation'),
      maxBareme: general.get('BaremeMaxDevoirs'),
      defaultPublicationInterval: general.get(
        'NbJDecalageDatePublicationParDefaut',
      ),
      publicationIntervalForParents: general.get(
        'NbJDecalagePublicationAuxParents',
      ),
      withGradesPublicationIntervalDisplayToParents: general.getB(
        'AvecAffichageDecalagePublicationNotesAuxParents',
      ),
      withTestsPublicationIntervalDisplayToParents: general.getB(
        'AvecAffichageDecalagePublicationEvalsAuxParents',
      ),
      allowedAnnotations: general.get('listeAnnotationsAutorisees'),
      acquirementLevels: general.getL<Map<String, dynamic>>(
        'ListeNiveauxDAcquisitions',
      ),
      showShorthandForAcquirementLevel: general.getB(
        'AfficherAbbreviationNiveauDAcquisition',
      ),
      withHistoricalTests: general.getB('AvecEvaluationHistorique'),
      withoutIntermediaryLevelValidationExamInAutomaticValidation: general.getB(
        'SansValidationNivIntermediairesDsValidAuto',
      ),
      onlyCountExamsForSchoolYearInAutomaticValidation: general.getB(
        'NeComptabiliserQueEvalsAnneeScoDsValidAuto',
      ),
      ponderateSubjectsRelativeToTheirCoefficientDomain: general.get(
        'PondererMatieresSelonLeurCoeffDsDomaine',
      ),
      cecrlLevelManagement: general.getB('AvecGestionNiveauxCECRL'),
      langActivityColor: general
          .get<String>('couleurActiviteLangagiere')
          .asRGB(),
      minimumBaremeForMCQQuestion: general.get('minBaremeQuestionQCM'),
      maximumBaremeForMCQQuestion: general.get('maxBaremeQuestionQCM'),
      maxPointsForMCQ: general.get('maxNbPointQCM'),
      maxLevelForMCQ: general.get('maxNiveauQCM'),
      skillGridElementLabelSize: general.get(
        'tailleLibelleElementGrilleCompetence',
      ),
      homeworkCommentSize: general.get('tailleCommentaireDevoir'),
      withConnexionInformationRetrieval: general.getB(
        'AvecRecuperationInfosConnexion',
      ),
      parentAuthorisesPasswordChange: general.getB('parentAutoriseChangerMDP'),
      font: general.get('Police'),
      fontSize: general.get('TaillePolice'),
      withAttachedStudents: general.getB('AvecElevesRattaches'),
      phoneMask: general.get('maskTelephone'),
      ectsMaximum: general.get('maxECTS'),
      appreciationMaxSize: general.getL<int>('TailleMaxAppreciation'),
      holidays: general.getLM('listeJoursFeries').mapL((e) => e.asHoliday()),
      showSequences: general.getB('afficherSequences'),
      starts: general.getLM('ListeHeures').mapL((e) => e.asTimeSlot()),
      endings: general.getLM('ListeHeuresFin').mapL((e) => e.asTimeSlot()),
      endingsForSL: general
          .getLM('ListeHeuresFinPourVS')
          .mapL((e) => e.asTimeSlot()),
      sequences: general.getL<String>('sequences'),
      periods: general.getLM('ListePeriodes').mapL((e) => e.asPeriod()),
      pauses: general.getLM('recreations').mapL((e) => e.asPause()),
      audioRecordingHomeworkSubmissionMaxSize: general.get(
        'tailleMaxEnregistrementAudioRenduTAF',
      ),
      validHomeworkSubmissionTypes: general.get('genresRenduTAFValable'),
      applicationCookieName: general.get('nomCookieAppli'),
      contextualHelp: general.get('aideContextuelle'),
    );
  }
}
