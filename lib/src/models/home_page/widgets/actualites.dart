part of '../widget.dart';

final class const Actualites({required final List<News> news})
    extends HomePageWidget {
  factory Actualites.decode(MapJsonNavigator nav, RemoteSession _) => .new(
    news: nav
        .go('actualites')
        .getL('listeModesAff')
        .getM(NewsDisplayMode.reception.id)
        .getLM('listeActualites')
        .mapL((e) => .decode(e)),
  );

  static HomePageModule module() =>
      HomePageModule(widget: .actualites, data: (session) => {});

  @override
  HomePageWidgetType get widgetId => .actualites;

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
