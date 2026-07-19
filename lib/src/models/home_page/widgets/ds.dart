part of '../widget.dart';

class DS extends HomePageWidget {
  static HomePageModule module() =>
      HomePageModule(widget: .ds, data: (session) => {});

  final List<ExamPreview> exams;

  const DS({required this.exams});

  @override
  HomePageWidgetType get widgetId => .ds;

  DS.decode(MapJsonNavigator nav, RemoteSession _)
    : exams = nav
          .go('devoirSurveille')
          .getLM('listeDS')
          .mapL((e) => e.asExamPreview());

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
