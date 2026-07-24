part of '../widget.dart';

final class const VieScolaire({
  required final String elementTypes,
  required final List<SchoolLifeEvent> absences,
  required final bool absenceCommentRequired,
  required final bool lateArrivalCommentRequired,
}) extends HomePageWidget {
  factory decode(MapJsonNavigator nav, RemoteSession _) => .new(
    elementTypes: nav.go('vieScolaire').get('L'),
    absences: nav
        .go('vieScolaire')
        .getLM('listeAbsences')
        .mapL((e) => e.asSchoolLifeEvent()),
    absenceCommentRequired: nav
        .go('vieScolaire')
        .getB('commentaireAbsenceObligatoire'),
    lateArrivalCommentRequired: nav
        .go('vieScolaire')
        .getB('commentaireRetardObligatoire'),
  );

  static HomePageModule module() =>
      HomePageModule(widget: .vieScolaire, data: (session) => {});

  @override
  HomePageWidgetType get widgetId => .vieScolaire;

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
