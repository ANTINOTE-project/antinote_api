part of '../widget.dart';

class Actualites extends HomePageWidget {
  final List<News> news;

  const Actualites({required this.news});

  @override
  HomePageWidgetType get widgetId => HomePageWidgetType.actualites;

  Actualites.decode(MapJsonNavigator nav, PronoteSession _)
    : news = nav
          .go('actualites')
          .getL('listeModesAff')
          .getM(NewsDisplayMode.reception.id)
          .getLM('listeActualites')
          .mapL((e) => e.asNews());

  static final definition = WidgetDefinition(
    type: HomePageWidgetType.actualites,
    shouldCreate: (nav, _) =>
        nav
            .mGo('actualites')
            ?.mGetL('listeModesAff')
            ?.getM(NewsDisplayMode.reception.id)
            .getL('listeActualites')
            .isNotEmpty ??
        false,
    create: Actualites.decode,
  );

  @override
  List<VisualIdMixin> get toStore => news;
}
