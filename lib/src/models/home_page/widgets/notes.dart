part of '../widget.dart';

final class const Notes({required final LatestGradesPage page})
    extends HomePageWidget {
  factory decode(Map<String, dynamic> nav, RemoteSession _) =>
      .new(page: .decode(nav.getM('notes')));

  static HomePageModule module() =>
      HomePageModule(widget: .notes, data: (session) => {});

  @override
  HomePageWidgetType get widgetId => .notes;

  static final definition = WidgetDefinition(
    type: .notes,
    shouldCreate: (nav, _) =>
        nav.mGo('notes')?.mGetL('listeDevoirs')?.notEmpty ?? false,
    create: Notes.decode,
  );

  @override
  List<VisualIdMixin> get toStore => [
    ...page.exams,
    ...?page.services,
    ?page.period,
  ];
}
