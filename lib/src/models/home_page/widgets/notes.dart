part of '../widget.dart';

class Notes extends HomePageWidget {
  final LatestGradesPage page;

  const Notes(this.page);

  @override
  HomePageWidgetType get widgetId => HomePageWidgetType.notes;

  static final definition = WidgetDefinition(
    type: HomePageWidgetType.notes,
    shouldCreate: (nav, _) =>
        nav.mGo('notes')?.mGetL('listeDevoirs')?.notEmpty ?? false,
    create: (nav, _) => Notes(nav.getM('notes').asLatestGradesPage()),
  );

  @override
  List<VisualIdMixin> get toStore => [
    ...page.exams,
    ...?page.services,
    ?page.period,
  ];
}
