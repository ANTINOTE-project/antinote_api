part of '../widget.dart';

final class const EDT({
  required final Timetable timetable,
  required final int selectedCycleDay,
  required final int? currentSlot,
}) extends HomePageWidget {
  factory decode(MapJsonNavigator nav, RemoteSession session) => .new(
    timetable: Timetable(
      withCanceledClasses: nav.get('avecCoursAnnule'),
      classes: nav.getLM('ListeCours').mapL((e) => .decode(session, e))
        ..sort(
          (a, b) => a.startDate.millisecondsSinceEpoch.compareTo(
            b.startDate.millisecondsSinceEpoch,
          ),
        ),
      absences: nav.get('absences'),
      firstSlotForDay: nav.get('premierePlaceHebdoDuJour'),
      middayMealStartSlot: nav.get('debutDemiPensionHebdo'),
      middayMealEndSlot: nav.get('finDemiPensionHebdo'),
      breaks: nav.getLM('recreations').mapL((e) => .decode(e)),
    ),
    selectedCycleDay: nav.get('jourCycleSelectionne'),
    currentSlot: nav.get('placeCourante'),
  );

  // TODO: Probably delete this as it could give misleading information.
  factory EDT.decodeUpdate(
    EDT old,
    MapJsonNavigator nav,
    RemoteSession session,
  ) => .new(
    timetable: Timetable(
      withCanceledClasses: nav.get('avecCoursAnnule'),
      classes: nav.getLM('ListeCours').mapL((e) => .decode(session, e))
        ..sort(
          (a, b) => a.startDate.millisecondsSinceEpoch.compareTo(
            b.startDate.millisecondsSinceEpoch,
          ),
        ),
      absences: nav.get('absences'),
      firstSlotForDay: nav.get('premierePlaceHebdoDuJour'),
      middayMealStartSlot: nav.get('debutDemiPensionHebdo'),
      middayMealEndSlot: nav.get('finDemiPensionHebdo'),
      breaks: nav.getLM('recreations').mapL((e) => .decode(e)),
    ),
    selectedCycleDay: nav.get('jourCycleSelectionne'),
    currentSlot: nav.get('placeCourante') ?? old.currentSlot,
  );

  static HomePageModule module(Date date) => HomePageModule(
    widget: .edt,
    data: (session) => {
      'numeroSemaine': date.toRemoteWeekNumber(session),
      'date': {'_T': 7, 'V': date.asRemoteDate()},
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
    update: EDT.decodeUpdate,
  );

  @override
  List<VisualIdMixin> get toStore => [...timetable.classes];
}
