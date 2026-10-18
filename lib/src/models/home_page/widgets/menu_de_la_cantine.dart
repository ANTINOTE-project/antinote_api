part of '../widget.dart';

final class const MenuDeLaCantine({required final Menu currentMenu})
    extends HomePageWidget {
  factory decode(
    Map<String, dynamic> nav,
    HomePageModule? module,
    RemoteSession session,
  ) => .new(
    currentMenu: Menu.decode(
      nav.go('menuDeLaCantine'),
      time:
          module?.data(session).mGo('menuDeLaCantine')?.get('date') ??
          session.instance.nextBusinessDay,
    ),
  );

  static HomePageModule module(Date date) => HomePageModule(
    widget: .menuDeLaCantine,
    data: (session) => {
      'menuDeLaCantine': {'date': date},
    },
  );

  @override
  HomePageWidgetType get widgetId => .menuDeLaCantine;

  static final definition = WidgetDefinition(
    type: .menuDeLaCantine,
    shouldCreate: (nav, _) =>
        nav.mGo('menuDeLaCantine')?.mGetL('listeRepas')?.notEmpty ?? false,
    create: MenuDeLaCantine.decode,
  );

  @override
  List<VisualNavigator> get toStore => [
    .go(currentMenu, field: 'menuDeLaCantine'),
  ];
}
