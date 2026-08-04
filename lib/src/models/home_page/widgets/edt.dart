part of '../widget.dart';

final class const EDT({
  required final Timetable timetable,
  required final int selectedCycleDay,
  required final int? currentSlot,
}) extends HomePageWidget {
  factory decode(Map<String, dynamic> nav, RemoteSession session) => .new(
    timetable: Timetable.decode(nav, session),
    selectedCycleDay: nav.get('jourCycleSelectionne'),
    currentSlot: nav.get('placeCourante'),
  );

  static HomePageModule module(Date date) => HomePageModule(
    widget: .edt,
    canQuerySpecifically: true,
    data: (session) => {
      'EDT': {'numeroSemaine': date.toRemoteWeekNumber(session), 'date': date},
    },
  );

  @override
  HomePageWidgetType get widgetId => .edt;

  static final definition = WidgetDefinition(
    type: .edt,
    shouldCreate: (nav, session) {
      return nav.mGetL('ListeCours')?.isNotEmpty ?? false;
    },
    create: EDT.decode,
  );

  @override
  List<VisualNavigator> get toStore => [.stay(timetable)];
}
