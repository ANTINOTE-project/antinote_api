part of '../widget.dart';

class VieScolaire extends HomePageWidget {
  static HomePageModule module() =>
      HomePageModule(widget: .vieScolaire, data: (session) => {});

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
  HomePageWidgetType get widgetId => .vieScolaire;

  VieScolaire.decode(MapJsonNavigator nav, RemoteSession _)
    : elementTypes = nav.go('vieScolaire').get('L'),
      absences = nav
          .go('vieScolaire')
          .getLM('listeAbsences')
          .mapL((e) => e.asSchoolLifeEvent()),
      absenceCommentRequired = nav
          .go('vieScolaire')
          .getB('commentaireAbsenceObligatoire'),
      lateArrivalCommentRequired = nav
          .go('vieScolaire')
          .getB('commentaireRetardObligatoire');

  static final definition = WidgetDefinition(
    type: .vieScolaire,
    shouldCreate: (nav, _) {
      return nav.mGo('vieScolaire')?.mGetL('listeAbsences')?.isNotEmpty ??
          false;
    },
    create: VieScolaire.decode,
  );

  @override
  List<VisualIdMixin> get toStore => [...absences];
}
