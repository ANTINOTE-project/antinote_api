import 'package:antinote/src/helpers/enum_id.dart';

enum WorkspaceCategory {
  forStudent,
  student,
  parent,
  forTeacher,
  mobile,
  forPrimary,
  primaryTheme,
  mcqExecution,
  withHomePage,
  couldEditInformation,
  hasNoLocker;
}

enum WorkspaceType implements EnumId {
  // Find/Replace method of editing all of this:
  // Find field: \"(?<prefix>.*?)Eleve(?<suffix>.*?)\"\, categories\: \[
  // Replace field: "${prefix}Eleve${suffix}", categories: [.student

  // Or use a macro by putting the PRONOTE names in a list and using the relevant macro:
  /*
      <macro name="Add something">
      <action id="EditorNextWordWithSelection" />
      <action id="Find" />
      <shortuct text="RIGHT" />
      <typing text-keycode="222:1">&quot;</typing>
      <action id="EditorPreviousWord" />
      <action id="EditorPreviousWord" />
      <typing text-keycode="222:1">&quot;</typing>
      <shortuct text="LEFT" />
      <shortuct text="ENTER" />
      <shortuct text="ESCAPE" />
      <action id="EditorRight" />
      <action id="EditorNextWord" />
      <action id="EditorNextWord" />
      <action id="EditorNextWord" />
      <action id="EditorNextWord" />
      <typing text-keycode="46:0;83:0;79:0;77:0;69:0;84:0;72:0;73:0;78:0;71:0;44:0;32:0">.something,&amp;#x20;</typing>
      <action id="Find" />
      <shortuct text="RIGHT" />
      <action id="EditorBackSpace" />
      <action id="EditorPreviousWord" />
      <action id="EditorBackSpace" />
      <typing text-keycode="32:0;32:0;32:0;32:0;32:0;32:0">&amp;#x20;&amp;#x20;&amp;#x20;&amp;#x20;&amp;#x20;&amp;#x20;</typing>
      <shortuct text="ENTER" />
      <shortuct text="ENTER" />
      <shortuct text="ESCAPE" />
      <action id="EditorRight" />
      <action id="EditorPreviousWord" />
      <action id="EditorDown" />
    </macro>
  * */

  // dart format off
  commun(0, "Commun", categories: []),
  professeur(1, "Professeur", categories: [.couldEditInformation, .withHomePage, .forTeacher, ]),
  parent(2, "Parent", categories: [.hasNoLocker, .withHomePage, .parent, .forStudent,]),
  eleve(3, "Eleve", categories: [.hasNoLocker, .withHomePage, .student, .mcqExecution, .forStudent,]),
  entreprise(4, "Entreprise", categories: [.withHomePage, .forStudent,]),
  academie(5, "Academie", categories: [.forTeacher, ]),
  mobileEleve(6, "Mobile_Eleve", categories: [.hasNoLocker, .withHomePage, .student, .mcqExecution, .forStudent,.mobile]),
  mobileParent(7, "Mobile_Parent", categories: [.hasNoLocker, .withHomePage, .parent, .forStudent, .mobile]),
  mobileProfesseur(8, "Mobile_Professeur", categories: [.couldEditInformation, .withHomePage, .forTeacher, .mobile]),
  mobileCommun(9, "Mobile_Commun", categories: [.mobile]),
  etablissement(13, "Etablissement", categories: [.couldEditInformation, .withHomePage, ]),
  mobileEtablissement(14, "Mobile_Etablissement", categories: [.couldEditInformation, .withHomePage, .mobile]),
  gestionSSO(15, "Gestion_SSO", categories: []),
  administrateur(16, "Administrateur", categories: [.withHomePage, ]),
  mobileAdministrateur(17, "Mobile_Administrateur", categories: [.withHomePage, .mobile]),
  inscription(18, "Inscription", categories: []),
  primProfesseur(19, "PrimProfesseur", categories: [.withHomePage, .forPrimary, ]),
  primParent(20, "PrimParent", categories: [.withHomePage, .mcqExecution, .primaryTheme, .forPrimary, .parent, .forStudent, ]),
  mobilePrimProfesseur(21, "Mobile_PrimProfesseur", categories: [.withHomePage, .forPrimary, .mobile, ]),
  mobilePrimParent(22, "Mobile_PrimParent", categories: [.withHomePage, .mcqExecution, .primaryTheme, .forPrimary, .parent, .forStudent, .mobile, ]),
  primEleve(23, "PrimEleve", categories: [.withHomePage, .primaryTheme, .forPrimary, .student, .mcqExecution, .forStudent, ]),
  mobilePrimEleve(24, "Mobile_PrimEleve", categories: [.withHomePage, .primaryTheme, .forPrimary, .student, .mcqExecution, .forStudent, .mobile, ]),
  accompagnant(25, "Accompagnant", categories: [.withHomePage, .forStudent, ]),
  mobileAccompagnant(26, "Mobile_Accompagnant", categories: [.withHomePage, .forStudent, .mobile]),
  primAccompagnant(27, "PrimAccompagnant", categories: [.withHomePage, .primaryTheme, .forPrimary, .forStudent, ]),
  mobilePrimAccompagnant(28, "Mobile_PrimAccompagnant", categories: [.withHomePage, .primaryTheme, .forPrimary, .forStudent, .mobile, ]),
  tuteur(29, "Tuteur", categories: [.withHomePage, .forStudent, ]),
  mobileTuteur(30, "Mobile_Tuteur", categories: [.withHomePage, .forStudent, .mobile]),
  primPeriscolaire(31, "PrimPeriscolaire", categories: [.withHomePage, .forPrimary, ]),
  mobilePrimPeriscolaire(32, "Mobile_PrimPeriscolaire", categories: [.withHomePage, .forPrimary, .mobile, ]),
  pagePubliqueEtablissement(33, "PagePubliqueEtablissement", categories: []),
  mobilePagePubliqueEtablissement(34, "Mobile_PagePubliqueEtablissement", categories: [.mobile]),
  primMairie(35, "PrimMairie", categories: [.withHomePage, .forPrimary, ]),
  mobilePrimMairie(36, "Mobile_PrimMairie", categories: [.withHomePage, .forPrimary, .mobile, ]),
  primDirection(37, "PrimDirection", categories: [.withHomePage, .forPrimary, ]),
  mobilePrimDirection(38, "Mobile_PrimDirection", categories: [.withHomePage, .forPrimary, .mobile, ]),
  mobileEntreprise(39, "Mobile_Entreprise", categories: [.withHomePage, .forStudent, .mobile]);
  // dart format on

  @override
  final int id;
  final String pronoteId;
  final List<WorkspaceCategory> categories;

  const WorkspaceType(this.id, this.pronoteId,
      {required this.categories});
}
