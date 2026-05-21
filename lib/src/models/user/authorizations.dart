import 'package:antinote/src/helpers/json.dart';

/// Thanks again Mikkel ALMONTE-RINGAUD from the Pawnote.js project for the
/// descriptions. Licensing information available in the app.
final class UserAuthorizations {
  final bool canReadDiscussions;
  final bool canDiscuss;
  final bool canDiscussWithStaff;
  final bool canDiscussWithParents;
  final bool canDiscussWithStudents;
  final bool canDiscussWithTeachers;
  final bool hasAdvancedDiscussionEditor;
  final double? maxAssignmentFileUploadSize;

  final List<int> tabLocations;

  const UserAuthorizations({
    required this.canReadDiscussions,
    required this.canDiscuss,
    required this.canDiscussWithStaff,
    required this.canDiscussWithParents,
    required this.canDiscussWithStudents,
    required this.canDiscussWithTeachers,
    required this.hasAdvancedDiscussionEditor,
    required this.maxAssignmentFileUploadSize,
    required this.tabLocations,
  });
}

/*
* _estEnConsultation(0), debugger eval code:11:29
_cours_domaineConsultationEDT(1), debugger eval code:11:29
_cours_avecReservationCreneauxLibres(2), debugger eval code:11:29
_cours_modifierElevesDetachesSurCoursDeplaceCreneauLibre(3), debugger eval code:11:29
_cours_modifierMatieres(4), debugger eval code:11:29
_cours_modifierMatieresCoursEPIEtAP(5), debugger eval code:11:29
_cours_modifierClasses(6), debugger eval code:11:29
_cours_modifierProfesseurs(7), debugger eval code:11:29
_cours_modifierSalles(8), debugger eval code:11:29
_cours_modifierMateriels(9), debugger eval code:11:29
_cours_creerCours(10), debugger eval code:11:29
_cours_creerCoursPermanenceFeuilleAppel(11), debugger eval code:11:29
_cours_deplacerCours(12), debugger eval code:11:29
_cours_estSemaineModifiable(13), debugger eval code:11:29
_cours_estGestionnaireSalle(14), debugger eval code:11:29
_cours_estGestionnaireMateriel(15), debugger eval code:11:29
_cours_avecMateriel(16), debugger eval code:11:29
_cours_avecFicheCoursConseil(17), debugger eval code:11:29
_cours_masquerPartiesDeClasse(18), debugger eval code:11:29
_cours_afficherElevesDetachesDansCours(19), debugger eval code:11:29
_eleves_voirTousLesEleves(20), debugger eval code:11:29
_eleves_consulterIdentiteEleve(21), debugger eval code:11:29
_eleves_consulterFichesResponsables(22), debugger eval code:11:29
_eleves_consulterPhotosEleves(23), debugger eval code:11:29
_eleves_avecSaisieParcoursPedagogique(24), debugger eval code:11:29
_eleves_avecAffectationElevesGroupesNonGAEV(25), debugger eval code:11:29
_eleves_avecAffectationElevesGroupesGAEV(26), debugger eval code:11:29
_eleves_avecSaisieProjetIndividuel(27), debugger eval code:11:29
_eleves_avecSaisieAttestations(28), debugger eval code:11:29
_eleves_consulterDonneesAdministrativesAutresEleves(29), debugger eval code:11:29
_communication_toutesClasses(30), debugger eval code:11:29
_communication_avecDiscussion(31), debugger eval code:11:29
_communication_discussionDesactiveeSelonHoraire(32), debugger eval code:11:29
_communication_messageDiscussionDesactiveeSelonHoraire(33), debugger eval code:11:29
_communication_discussionInterdit(34), debugger eval code:11:29
_communication_avecDiscussionPersonnels(35), debugger eval code:11:29
_communication_avecDiscussionProfesseurs(36), debugger eval code:11:29
_communication_avecDiscussionParents(37), debugger eval code:11:29
_communication_avecDiscussionEleves(38), debugger eval code:11:29
_communication_avecMessageInstantane(39), debugger eval code:11:29
_communication_avecContactVS(40), debugger eval code:11:29
_communication_lancerAlertesPPMS(41), debugger eval code:11:29
_communication_estDestinataireChat(42), debugger eval code:11:29
_communication_avecDiscussionAvancee(43), debugger eval code:11:29
_communication_avecPublicationPageEtablissement(44), debugger eval code:11:29
_absences_domaineRecapitulatifAbsences(45), debugger eval code:11:29
_absences_avecSaisieAppelEtVS(46), debugger eval code:11:29
_absences_avecSaisieAppel(47), debugger eval code:11:29
_absences_avecSaisieCours(48), debugger eval code:11:29
_absences_avecSaisieAbsenceOuverte(49), debugger eval code:11:29
_absences_avecSaisieHorsCours(50), debugger eval code:11:29
_absences_avecSaisieSurGrille(51), debugger eval code:11:29
_absences_avecSaisieSurGrilleAppelProf(52), debugger eval code:11:29
_absences_avecSaisieAbsence(53), debugger eval code:11:29
_absences_avecSaisieRetard(54), debugger eval code:11:29
_absences_avecSaisiePassageInfirmerie(55), debugger eval code:11:29
_absences_avecSaisieExclusion(56), debugger eval code:11:29
_absences_avecSaisiePunition(57), debugger eval code:11:29
_absences_avecSaisieObservation(58), debugger eval code:11:29
_absences_avecConsultationDefautCarnet(59), debugger eval code:11:29
_absences_avecSaisieDefautCarnet(60), debugger eval code:11:29
_absences_avecSaisieObservationsParents(61), debugger eval code:11:29
_absences_avecSaisieEncouragements(62), debugger eval code:11:29
_absences_avecAccesAuxEvenementsAutresCours(63), debugger eval code:11:29
_absences_avecSaisieAbsencesToutesPermanences(64), debugger eval code:11:29
_absences_listeDatesSaisieAbsence(65), debugger eval code:11:29
_absences_avecAnciennesFeuilleDAppel(66), debugger eval code:11:29
_absences_avecSaisieAbsencesGrilleAbsencesRepas(67), debugger eval code:11:29
_absences_avecSaisieAbsencesGrilleAbsencesInternat(68), debugger eval code:11:29
_absences_avecSuiviAbsenceRetard(69), debugger eval code:11:29
_absences_avecSaisieMotifRetard(70), debugger eval code:11:29
_absences_avecDeclarerUneAbsence(71), debugger eval code:11:29
_absences_avecDeclarerDispensePonctuelle(72), debugger eval code:11:29
_absences_avecDeclarerDispenseLongue(73), debugger eval code:11:29
_competence_avecSaisieEvaluations(74), debugger eval code:11:29
_competence_avecSaisieItems(75), debugger eval code:11:29
_competence_avecValidationCompetences(76), debugger eval code:11:29
_agenda_avecSaisieAgenda(77), debugger eval code:11:29
_actualite_avecSaisieActualite(78), debugger eval code:11:29
_listeDiffusion_avecPublication(79), debugger eval code:11:29
_casierNumerique_avecAccesALaListeDesDocumentEleve(80), debugger eval code:11:29
_casierNumerique_gererLaCollecteDeDocuments(81), debugger eval code:11:29
_casierNumerique_collecterDocsAupresDesEleves(82), debugger eval code:11:29
_casierNumerique_collecterDocsAupresDesResponsables(83), debugger eval code:11:29
_casierNumerique_avecSaisieDocumentsCasiersIntervenant(84), debugger eval code:11:29
_casierNumerique_avecSaisieDocumentsCasiersResponsable(85), debugger eval code:11:29
_casierNumerique_accesSignatureNumerique(86), debugger eval code:11:29
_dossierVS_creerDossiersVS(87), debugger eval code:11:29
_dossierVS_modifierDossiersVS(88), debugger eval code:11:29
_dossierVS_saisieMotifsDossiersVS(89), debugger eval code:11:29
_dossierVS_publierDossiersVS(90), debugger eval code:11:29
_dossierVS_consulterMemosEleve(91), debugger eval code:11:29
_dossierVS_saisirMemos(92), debugger eval code:11:29
_decrochageScolaire_acces(93), debugger eval code:11:29
_decrochageScolaire_suivi(94), debugger eval code:11:29
_dispenses_saisie(95), debugger eval code:11:29
_incidents_acces(96), debugger eval code:11:29
_incidents_uniquementMesIncidentsSignales(97), debugger eval code:11:29
_incidents_saisie(98), debugger eval code:11:29
_incidents_publier(99), debugger eval code:11:29
_punition_avecPublicationPunitions(100), debugger eval code:11:29
_punition_acces(101), debugger eval code:11:29
_punition_saisie(102), debugger eval code:11:29
_punition_avecRecapPunitions(103), debugger eval code:11:29
_punition_avecRecapSanctions(104), debugger eval code:11:29
_creerMotifIncidentPunitionSanction(105), debugger eval code:11:29
_stage_autoriserEditionToutesOffresStages(106), debugger eval code:11:29
_cahierDeTexte_avecSaisieCahierDeTexte(107), debugger eval code:11:29
_cahierDeTexte_creerCategoriesDeCahierDeTexte(108), debugger eval code:11:29
_cahierDeTexte_avecSaisiePieceJointe(109), debugger eval code:11:29
_cahierDeTexte_tailleMaxPieceJointe(110), debugger eval code:11:29
_notation_avecSaisieDevoirs(111), debugger eval code:11:29
_compte_avecSaisieIdentifiant(112), debugger eval code:11:29
_compte_avecSaisieMotDePasse(113), debugger eval code:11:29
_compte_avecSaisieMotDePasseEleve(114), debugger eval code:11:29
_compte_avecInformationsPersonnelles(115), debugger eval code:11:29
_compte_avecSaisieInfosPersoCoordonnees(116), debugger eval code:11:29
_compte_avecSaisieInfosPersoAutorisations(117), debugger eval code:11:29
_intendance_avecDemandeTravauxIntendance(118), debugger eval code:11:29
_intendance_uniquementMesTravauxIntendance(119), debugger eval code:11:29
_intendance_avecExecutionTravauxIntendance(120), debugger eval code:11:29
_intendance_avecGestionTravauxIntendance(121), debugger eval code:11:29
_intendance_avecDemandeTachesSecretariat(122), debugger eval code:11:29
_intendance_uniquementMesTachesSecretariat(123), debugger eval code:11:29
_intendance_avecExecutionTachesSecretariat(124), debugger eval code:11:29
_intendance_avecDemandeTachesInformatique(125), debugger eval code:11:29
_intendance_uniquementMesTachesInformatique(126), debugger eval code:11:29
_intendance_avecExecutionTachesInformatique(127), debugger eval code:11:29
_intendance_avecGestionTachesInformatique(128), debugger eval code:11:29
_intendance_avecDemandeCommandes(129), debugger eval code:11:29
_intendance_uniquementMesCommandes(130), debugger eval code:11:29
_intendance_avecExecutionCommandes(131), debugger eval code:11:29
_intendance_avecGestionCommandes(132), debugger eval code:11:29
_services_avecCreationSousServices(133), debugger eval code:11:29
_services_avecModificationCoefGeneral(134), debugger eval code:11:29
_trombinoscope_autoriseAConsulterPhotosDeTousLesEleves(135), debugger eval code:11:29
_forum_avecCreationSujetForum(136), debugger eval code:11:29
_forum_avecModificationForumAPosteriori(137), debugger eval code:11:29
_autoriserImpressionBulletinReleveBrevet(138), debugger eval code:11:29
_fonctionnalites_gestionNotation(139), debugger eval code:11:29
_fonctionnalites_gestionCompetences(140), debugger eval code:11:29
_fonctionnalites_gestionBrevet(141), debugger eval code:11:29
_fonctionnalites_gestionProgrammesBO(142), debugger eval code:11:29
_fonctionnalites_gestionStages(143), debugger eval code:11:29
_fonctionnalites_gestionIPR(144), debugger eval code:11:29
_fonctionnalites_appelSaisirMotifJustifDAbsence(145), debugger eval code:11:29
_fonctionnalites_gestionTwitter(146), debugger eval code:11:29
_fonctionnalites_gestionBulletinClasse(147), debugger eval code:11:29
_fonctionnalites_gestionPunitions(148), debugger eval code:11:29
_fonctionnalites_gestionInfirmerie(149), debugger eval code:11:29
_fonctionnalites_gestionPermanence(150), debugger eval code:11:29
_fonctionnalites_gestionAbsencesDemiPension(151), debugger eval code:11:29
_fonctionnalites_gestionAbsencesInternat(152), debugger eval code:11:29
_fonctionnalites_gestionEtendueEleves(153), debugger eval code:11:29
_fonctionnalites_gestionEleves(154), debugger eval code:11:29
_fonctionnalites_gestionPersonnels(155), debugger eval code:11:29
_fonctionnalites_forcerARInfos(156), debugger eval code:11:29
_fonctionnalites_gestionSondageAnonyme(157), debugger eval code:11:29
_fonctionnalites_gestionAbsenceDJParUtilisateur(158), debugger eval code:11:29
_fonctionnalites_attestationEtendue(159), debugger eval code:11:29
_fonctionnalites_afficherProjetsAccompagnement(160), debugger eval code:11:29
_fonctionnalites_saisieEtendueAbsenceDepuisAppel(161), debugger eval code:11:29
_fonctionnalites_importExportEducationNationale(162), debugger eval code:11:29
_fonctionnalites_avecCommissions(163), debugger eval code:11:29
_fonctionnalites_gestionCDT(164), debugger eval code:11:29
_fonctionnalites_gestionPeriodeNotation(165), debugger eval code:11:29
_fonctionnalites_gestionARBulletins(166), debugger eval code:11:29
_fonctionnalites_avecTransformationFluxFichier(167), debugger eval code:11:29
_fonctionnalites_gestionQCM(168), debugger eval code:11:29
_fonctionnalites_gestionInfosSondage(169), debugger eval code:11:29
_avecAccesRemplacementsProfs(170), debugger eval code:11:29
_voirAbsencesEtRemplacementsProfs(171), debugger eval code:11:29
_sePorterVolontaireRemplacement(172), debugger eval code:11:29
_avecSaisieAppreciationsGenerales(173), debugger eval code:11:29
_assistantSaisieAppreciations(174), debugger eval code:11:29
_tailleMaxDocJointEtablissement(175), debugger eval code:11:29
_tailleMaxRenduTafEleve(176), debugger eval code:11:29
_tailleTravailAFaire(177), debugger eval code:11:29
_tailleCirconstance(178), debugger eval code:11:29
_tailleCommentaire(179), debugger eval code:11:29
_avecDroitDeconnexionMessagerie(180), debugger eval code:11:29
_estDirecteur(181), debugger eval code:11:29
_estEnseignant(182), debugger eval code:11:29
_tailleMaxUpload(183), debugger eval code:11:29*/
extension AsUserAuthorizations on MapJsonNavigator {
  UserAuthorizations asUserAuthorizations() {
    final authorizations = go('autorisations');

    final canReadDiscussions = authorizations.get('AvecDiscussion') ?? false;
    final canDiscuss =
        canReadDiscussions &&
        !(authorizations.get('discussionInterdit') ?? false);
    final canDiscussWithStaff =
        canDiscuss && (authorizations.get('AvecDiscussionPersonnels') ?? false);
    final canDiscussWithParents =
        canDiscuss && (authorizations.get('AvecDiscussionParents') ?? false);
    final canDiscussWithStudents =
        canDiscuss && (authorizations.get('AvecDiscussionEleves') ?? false);
    final canDiscussWithTeachers =
        canDiscuss &&
        (authorizations.get('AvecDiscussionProfesseurs') ?? false);

    final tabs = getLM('listeOnglets');

    final List<int> locations = [];
    if (tabs.notEmpty) {
      void traverse(MapJsonNavigator obj) {
        if (obj.has('G')) {
          locations.add(obj.get('G'));
        }

        if (obj.has('Onglet')) {
          obj.getLM('Onglet').forEach(traverse);
        }
      }

      tabs.forEach(traverse);
    }

    return UserAuthorizations(
      canReadDiscussions: canReadDiscussions,
      canDiscuss: canDiscuss,
      canDiscussWithStaff: canDiscussWithStaff,
      canDiscussWithParents: canDiscussWithParents,
      canDiscussWithStudents: canDiscussWithStudents,
      canDiscussWithTeachers: canDiscussWithTeachers,
      hasAdvancedDiscussionEditor:
          authorizations.get('AvecDiscussionAvancee') ?? false,
      maxAssignmentFileUploadSize: authorizations.get('tailleMaxRenduTafEleve'),
      tabLocations: locations,
    );
  }
}
