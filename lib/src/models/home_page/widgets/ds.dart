part of '../widget.dart';

final class const DS({required final List<ExamPreview> exams})
    extends HomePageWidget {
  factory decode(Map<String, dynamic> nav, RemoteSession _) => .new(
    exams: nav.go('devoirSurveille').getLM('listeDS').mapL((e) => .decode(e)),
  );

  static HomePageModule module() => HomePageModule(
    widget: .ds,
    canQuerySpecifically: true,
    data: (session) => {},
  );

  @override
  HomePageWidgetType get widgetId => .ds;

  static final definition = WidgetDefinition(
    type: .ds,
    shouldCreate: (nav, _) =>
        nav
            .mGo('devoirSurveille')
            ?.mGetLM('listeDS')
            ?.any(
              (element) => element.get('G') == 0,
            ) ?? // 0: devoir 1: evaluation
        false,
    create: DS.decode,
  );

  @override
  List<VisualIdMixin> get toStore => exams;
}
