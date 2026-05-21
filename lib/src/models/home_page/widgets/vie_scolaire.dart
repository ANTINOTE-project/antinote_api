part of '../widget.dart';

class VieScolaire extends HomePageWidget {
  final String elementTypes;
  final List<SchoolLifeEvent> absences;
  final bool absenceCommentRequired;
  final bool lateArrivalCommentRequired;

  const VieScolaire({
    required this.elementTypes,
    required this.absences,
    required this.absenceCommentRequired,
    required this.lateArrivalCommentRequired,
  });

  @override
  HomePageWidgetType get widgetId => HomePageWidgetType.vieScolaire;

  VieScolaire.decode(MapJsonNavigator nav, PronoteSession _)
    : elementTypes = nav.go('vieScolaire').get('L'),
      absences = nav
          .go('vieScolaire')
          .getLM('listeAbsences')
          .mapL((e) => e.asSchoolLifeEvent()),
      absenceCommentRequired = nav
          .go('vieScolaire')
          .get('commentaireAbsenceObligatoire'),
      lateArrivalCommentRequired = nav
          .go('vieScolaire')
          .get('commentaireRetardObligatoire');

  static final definition = WidgetDefinition(
    type: HomePageWidgetType.vieScolaire,
    shouldCreate: (nav, _) {
      return nav.mGo('vieScolaire')?.mGetL('listeAbsences')?.isNotEmpty ??
          false;
    },
    create: VieScolaire.decode,
  );

  @override
  List<VisualIdMixin> get toStore => [...absences];
}
