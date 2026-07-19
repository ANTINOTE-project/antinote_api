part of '../widget.dart';

class Actualites extends HomePageWidget {
  static HomePageModule module() =>
      HomePageModule(widget: .actualites, data: (session) => {});

  final List<News> news;

  const Actualites({required this.news});

  @override
  HomePageWidgetType get widgetId => .actualites;

  Actualites.decode(MapJsonNavigator nav, RemoteSession _)
    : news = nav
          .go('actualites')
          .getL('listeModesAff')
          .getM(NewsDisplayMode.reception.id)
          .getLM('listeActualites')
          .mapL((e) => e.asNews());

  static final definition = WidgetDefinition(
    type: .actualites,
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
