library;

import 'package:antinote/src/accessors/home_page.dart';
import 'package:antinote/src/helpers/datetime.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/exam/preview.dart';
import 'package:antinote/src/models/grades/page.dart';
import 'package:antinote/src/models/homework/homework.dart';
import 'package:antinote/src/models/menu/menu.dart';
import 'package:antinote/src/models/news/display_mode.dart';
import 'package:antinote/src/models/news/news.dart';
import 'package:antinote/src/models/school_life_events/school_life_events.dart';
import 'package:antinote/src/models/timetable.dart';
import 'package:antinote/src/models/workspace/type.dart';

part 'widgets/actualites.dart';
part 'widgets/ds.dart';
part 'widgets/edt.dart';
part 'widgets/menu_de_la_cantine.dart';
part 'widgets/notes.dart';
part 'widgets/travail_a_faire.dart';
part 'widgets/vie_scolaire.dart';

List<WidgetDefinition> widgetDefinitions = [
  EDT.definition,
  Actualites.definition,
  DS.definition,
  MenuDeLaCantine.definition,
  TravailAFaire.definition,
  VieScolaire.definition,
  Notes.definition,
];

final class const WidgetDefinition<T extends HomePageWidget>({
  required final HomePageWidgetType type,
  required final bool Function(Map<String, dynamic> nav, RemoteSession session)
  shouldCreate,
  required final T Function(Map<String, dynamic> nav, RemoteSession session)
  create,
  final T Function(T old, Map<String, dynamic> nav, RemoteSession session)?
  update,
});

sealed class const HomePageWidget() {
  HomePageWidgetType get widgetId;

  List<VisualIdMixin> get toStore;
}

/// Scrapped from EGenreWidget, TODO localize.
enum HomePageWidgetType {
  discussions("discussions", 0),
  casier("casier", 1),
  appelNonFait("appelNonFait", 2),
  cdtNonSaisi("CDTNonSaisi", 3),
  conseilDeClasse("conseilDeClasse", 4),
  menuDeLaCantine("menuDeLaCantine", 5),
  vieScolaire("vieScolaire", 6),
  travailAFaire("travailAFaire", 7),
  agenda("agenda", 8),
  actualites("actualites", 9),
  notes("notes", 10),
  qcm("QCM", 11),
  edt("EDT", 12),
  ressources("ressources", 13),
  kiosque("kiosque", 14),
  ressourcePedagogique("ressourcePedagogique", 15),
  ds("DS", 16),
  aide("aide", 17),
  competences("competences", 18),
  coursNonAssures("coursNonAssures", 19),
  penseBete("penseBete", 20),
  dsEvaluation("DSEvaluation", 21),
  retourEspace("RetourEspace", 22),
  carnetDeCorrespondance("carnetDeCorrespondance", 23),
  encouragement("Encouragement", 24),
  tafARendre("TAFARendre", 25),
  intendanceExecute("IntendanceExecute", 26),
  lienUtile("lienUtile", 27),
  partenaireCDI("partenaireCDI", 28),
  partenaireAgate("partenaireAgate", 29),
  incidents("incidents", 30),
  donneesVS("donneesVS", 31),
  donneesProfs("donneesProfs", 32),
  tableauDeBord("tableauDeBord", 33),
  communications("communications", 34),
  connexionsEnCours("connexionsEnCours", 35),
  partenaireARD("partenaireARD", 36),
  personnelsAbsents("personnelsAbsents", 37),
  tachesSecretariatExecute("tachesSecretariatExecute", 38),
  planning("Planning", 39),
  elections("elections", 40),
  activite("activite", 41),
  enseignementADistance("enseignementADistance", 42),
  tafPrimaire("TAFPrimaire", 43),
  absRetardsJustifiesParents("absRetardsJustifiesParents", 44),
  blogFilActu("blogFilActu", 45),
  maintenanceInfoExecute("maintenanceInfoExecute", 46),
  tafEtActivites("TAFEtActivites", 47),
  evenementRappel("evenementRappel", 48),
  exclusions("exclusions", 49),
  partenaireApplicam("partenaireApplicam", 50),
  commandeExecute("commandeExecute", 51),
  registreAppel("registreAppel", 52),
  previsionnelAbsServiceAnnexe("previsionnelAbsServiceAnnexe", 53),
  partenaireFAST("partenaireFAST", 54),
  modificationEDT("modificationEDT", 55),
  remplacementsEnseignants("RemplacementsEnseignants", 56),
  voteElecMembreBureau("voteElecMembreBureau", 57),
  voteElecElecteur("voteElecElecteur", 58),
  infosParcoursupLSL("InfosParcoursupLSL", 59),
  documentsASigner("documentsASigner", 60);

  final String name;
  final int id;

  const HomePageWidgetType(this.name, this.id);
}
