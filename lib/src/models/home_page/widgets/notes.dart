part of '../widget.dart';

class Notes extends HomePageWidget {
  static HomePageModule module() =>
      HomePageModule(widget: .notes, data: (session) => {});

  final LatestGradesPage page;

  const Notes(this.page);

  @override
  HomePageWidgetType get widgetId => .notes;

  static final definition = WidgetDefinition(
    type: .notes,
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
