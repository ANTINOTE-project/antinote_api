part of '../widget.dart';

class EDT extends HomePageWidget {
  final Timetable timetable;
  final int selectedCycleDay;
  final int? currentSlot;

  const EDT({
    required this.timetable,
    required this.selectedCycleDay,
    required this.currentSlot,
  });

  @override
  HomePageWidgetType get widgetId => HomePageWidgetType.edt;

  EDT.decodeUpdate(EDT old, MapJsonNavigator nav, PronoteSession session)
    : timetable = Timetable(
        withCanceledClasses: nav.get('avecCoursAnnule'),
        classes: nav.getLM('ListeCours').mapL((e) => e.asClass(session))
          ..sort(
            (a, b) => a.startDate.millisecondsSinceEpoch.compareTo(
              b.startDate.millisecondsSinceEpoch,
            ),
          ),
        absences: nav.get('absences'),
        firstSlotForDay: nav.get('premierePlaceHebdoDuJour'),
        middayMealStartSlot: nav.get('debutDemiPensionHebdo'),
        middayMealEndSlot: nav.get('finDemiPensionHebdo'),
        breaks: nav.getLM('recreations').mapL((e) => e.asBreak()),
      ),
      selectedCycleDay = nav.get('jourCycleSelectionne'),
      currentSlot = nav.get('placeCourante') ?? old.currentSlot;

  EDT.decode(MapJsonNavigator nav, PronoteSession session)
    : timetable = Timetable(
        withCanceledClasses: nav.get('avecCoursAnnule'),
        classes: nav.getLM('ListeCours').mapL((e) => e.asClass(session))
          ..sort(
            (a, b) => a.startDate.millisecondsSinceEpoch.compareTo(
              b.startDate.millisecondsSinceEpoch,
            ),
          ),
        absences: nav.get('absences'),
        firstSlotForDay: nav.get('premierePlaceHebdoDuJour'),
        middayMealStartSlot: nav.get('debutDemiPensionHebdo'),
        middayMealEndSlot: nav.get('finDemiPensionHebdo'),
        breaks: nav.getLM('recreations').mapL((e) => e.asBreak()),
      ),
      selectedCycleDay = nav.get('jourCycleSelectionne'),
      currentSlot = nav.get('placeCourante');

  static final definition = WidgetDefinition(
    type: HomePageWidgetType.edt,
    shouldCreate: (nav, session) {
      return nav.mGetL('ListeCours')?.isNotEmpty ?? false;
    },
    create: EDT.decode,
    update: EDT.decodeUpdate,
  );

  @override
  List<VisualIdMixin> get toStore => [...timetable.classes];
}
