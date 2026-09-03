part of 'shared.dart';

final class SpecificInstanceParameters({
  required super.shared,

  required final DateTime serverDateTime,
  required final DateTime? demoDateTime,
  required final Workspace workspace,
  required final bool hostedInFrance,
  required final bool withForum,
  required final Uri? helpUrl,
  required final Uri? videosAccessUrl,
  required final Uri? twitterAccessUrl,
  required final Uri? doubleAuthRegistrationFAQUrl,
  required final Uri? securityVideoTutorialUrl,
  required final Uri? devicesRegisterTutorialUrl,
  required final Uri? canopeUrl,
  required final bool withConnexionChoice,
  required final int firstWeekNumber,
  required final Date firstCycleStartDate,
  required final Date firstMonday,
  required final Date firstDate,
  required final Date lastDate,
  required final int slotsPerDay,
  required final int slotsPerHour,
  required final double sequenceLength,
  required final int halfDayAbsenceSlot,
  required final int typeAbsencesViaDJ,
  required final bool defaultPresenceExemptionValue,
  required final bool lunchActivation,
  required final int lunchStartSlot,
  required final int lunchEndSlot,
  required final bool fullHoursAfterNoon,
  required final Date nextBusinessDay,
  required final List<int> businessDays,
  required final Set<int> lunchDays,
  required final bool discussionBetweenParentsActivated,
  required final bool excellenceParcoursGestion,
  required final bool blogActivation,
  required final int businessDaysPerCycle,
  required final int firstWeekday,
  required final int scheduleGridInCycle,
  required final Set<int> businessCycleDays,
  required final List<Set<int>> businessHalfDays,
  required final Map<int, WeekFrequency> weekFrequencies,
  required final Map<WeekFrequency, int?> weekFrequenciesPeriodicity,
  required final Map<WeekFrequency, WeekFrequency?> followingFrequencies,
  required final Grade bareme,
  required final Grade maxBareme,
  required final int defaultPublicationInterval,
  required final int publicationIntervalForParents,
  required final bool withGradesPublicationIntervalDisplayToParents,
  required final bool withTestsPublicationIntervalDisplayToParents,
  required final Set<int> allowedAnnotations,

  // TODO: Create models for those. (ListeNiveauxDAcquisitions)
  required final List<Map<String, dynamic>> acquirementLevels,
  required final bool showShorthandForAcquirementLevel,
  required final bool withHistoricalTests,
  required final bool
  withoutIntermediaryLevelValidationExamInAutomaticValidation,
  required final bool onlyCountExamsForSchoolYearInAutomaticValidation,
  required final bool ponderateSubjectsRelativeToTheirCoefficientDomain,
  required final bool cecrlLevelManagement,
  required final int langActivityColor,
  required final int minimumBaremeForMCQQuestion,
  required final int maximumBaremeForMCQQuestion,
  required final int maxPointsForMCQ,
  required final int maxLevelForMCQ,
  required final int skillGridElementLabelSize,
  required final int homeworkCommentSize,
  required final bool withConnexionInformationRetrieval,
  required final bool? parentAuthorisesPasswordChange,
  required final String? font,
  required final int? fontSize,
  required final bool withAttachedStudents,
  required final String phoneMask,
  required final int ectsMaximum,
  required final List<int> appreciationMaxSize,
  required final List<Holiday> holidays,
  required final bool showSequences,
  required final List<TimeSlot> starts,
  required final List<TimeSlot> endings,
  required final List<TimeSlot> endingsForSL,
  required final List<({DateTime start, DateTime end})> transferTimes,
  required final List<String> sequences,
  required final List<Period> periods,
  required final List<Pause> pauses,
  required final int audioRecordingHomeworkSubmissionMaxSize,
  required final Set<int> validHomeworkSubmissionTypes,
  required final String applicationCookieName,

  // TODO: Create a model for this. (aideContextuelle)
  required final Map<String, dynamic> contextualHelp,
}) extends InstanceParameters {
  factory decode(
    Map<String, dynamic> nav,
    SharedInstanceParameters shared,
    Workspace temporaryWorkspace,
  ) {
    final general = nav.getM('General');

    final (frequency, frequencyPeriodicity, followingFrequencies) =
        _buildWeekFrequenciesAndPeriodicity(nav);

    final starts = general.getLM('ListeHeures').mapL((e) => TimeSlot.decode(e));
    final endings = general
        .getLM('ListeHeuresFin')
        .mapL((e) => TimeSlot.decode(e));

    final transferTimes = _buildTransferTimes(starts, endings);

    return SpecificInstanceParameters(
      shared: shared,
      serverDateTime: nav.get('DateServeurHttp'),
      demoDateTime: nav.get('DateDemo'),
      workspace: Workspace(
        type: temporaryWorkspace.type,
        label: nav.get('Nom'),
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
      firstCycleStartDate: general
          .get<DateTime>('dateDebutPremierCycle')
          .toDay(),
      firstMonday: general.get<DateTime>('PremierLundi').toDay(),
      firstDate: general.get<DateTime>('PremiereDate').toDay(),
      lastDate: general.get<DateTime>('DerniereDate').toDay(),
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
      nextBusinessDay: general.get<DateTime>('JourOuvre').toDay(),
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
      holidays: general.getLM('listeJoursFeries').mapL((e) => .decode(e)),
      showSequences: general.getB('afficherSequences'),
      starts: starts,
      endings: endings,
      endingsForSL: general
          .getLM('ListeHeuresFinPourVS')
          .mapL((e) => .decode(e)),
      transferTimes: transferTimes,
      sequences: general.getL<String>('sequences'),
      periods: general.getLM('ListePeriodes').mapL((e) => .decode(e)),
      pauses: general.getLM('recreations').mapL((e) => .decode(e)),
      audioRecordingHomeworkSubmissionMaxSize: general.get(
        'tailleMaxEnregistrementAudioRenduTAF',
      ),
      validHomeworkSubmissionTypes: general.get('genresRenduTAFValable'),
      applicationCookieName: general.get('nomCookieAppli'),
      contextualHelp: general.get('aideContextuelle'),
    );
  }

  static (
    Map<int, WeekFrequency>,
    Map<WeekFrequency, int?>,
    Map<WeekFrequency, WeekFrequency?>,
  )
  _buildWeekFrequenciesAndPeriodicity(Map<String, dynamic> nav) {
    Map<int, WeekFrequency> weekFrequencies = {};

    for (final fortnight in [1, 2]) {
      final frequency = nav
          .go('General')
          .getL('DomainesFrequences')
          .getL<int>(fortnight);
      for (final week in frequency) {
        weekFrequencies[week] = WeekFrequency(
          label: nav.go('General').getL('LibellesFrequences').get(fortnight),
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

  /// Pauses aren't accounted for.
  static List<({DateTime start, DateTime end})> _buildTransferTimes(
    List<TimeSlot> starts,
    List<TimeSlot> endings,
  ) {
    assert(starts.length == endings.length);

    final transferTimes = <({DateTime start, DateTime end})>[];

    DateTime curTime = starts.first.timing;
    for (int i = 0; i < starts.length; i++) {
      final start = starts[i];
      final end = endings[i];

      if (!curTime.isAtSameMomentAs(start.timing)) {
        transferTimes.add((start: curTime, end: start.timing));
      }

      curTime = end.timing;
    }

    return transferTimes;
  }

  // TODO: fix negative first week number
  int getWeekNumberForDate(DateTime date) {
    return firstWeekNumber +
      ((date.toUtc().millisecondsSinceEpoch -
                  firstMonday.toUtc().millisecondsSinceEpoch) ~/
              (Duration.millisecondsPerSecond *
                  Duration.secondsPerMinute *
                  Duration.minutesPerHour *
                  Duration.hoursPerDay)) ~/
          7;
  }

  Date getDateForWeekNumber(int weekNumber) {
    return firstMonday
        .add(Duration(days: 7 * (weekNumber - firstWeekNumber)))
        .toDay();
  }

  List<Date> getDaysForWeekNumber(int weekNumber) {
    final base = getDateForWeekNumber(weekNumber);
    return [for (int i = 0; i < 7; i++) base.add(Duration(days: i)).toDay()];
  }

  DateTime timeForSlot(TimeSlot slot, DateTime day) {
    return day.copyWith(hour: slot.timing.hour, minute: slot.timing.minute);
  }

  // TODO: fix, when in nether regions (pauses), 0 is returned.
  int daySlotForTime(DateTime time) {
    for (int i = 0; i < starts.length; i++) {
      if (!starts[i].timing.isAfter(time) && endings[i].timing.isAfter(time)) {
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

  bool isBusinessHalfDay(DateTime time, [int? slot]) {
    if (!isBusinessDay(time.toDay())) return false;

    final placeSlot = slot ?? daySlotForTime(time);

    if (placeSlot < 0) return false;

    final int halfDay;
    if (placeSlot < lunchStartSlot) {
      halfDay = 0; // Morning
    } else if (placeSlot >= lunchEndSlot) {
      halfDay = 1; // Afternoon
    } else {
      halfDay = 0; // Somewhere in-between, considered morning afaik
    }

    return businessHalfDays[halfDay].contains(time.weekday - 1);
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
      date = date.add(const Duration(days: 1))
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
  List<VisualNavigator> get toStore => [
    for (final (index, holiday) in holidays.indexed)
      .new(
        exchanger: (nav) =>
            nav.go('General').getLM('listeJoursFeries').getM(index),
        value: holiday,
      ),

    for (final (index, period) in periods.indexed)
      .new(
        exchanger: (nav) =>
            nav.go('General').getLM('ListePeriodes').getM(index),
        value: period,
      ),
  ];
}
