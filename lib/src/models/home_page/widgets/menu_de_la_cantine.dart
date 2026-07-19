part of '../widget.dart';

class MenuDeLaCantine extends HomePageWidget {
  static HomePageModule module(Date date) => HomePageModule(
    widget: .menuDeLaCantine,
    data: (session) => {
      'menuDeLaCantine': {
        'date': {'_T': 7, 'V': date.asRemoteDate()},
      },
    },
  );

  final Menu currentMenu;

  const MenuDeLaCantine({required this.currentMenu});

  @override
  HomePageWidgetType get widgetId => .menuDeLaCantine;

  MenuDeLaCantine.decode(MapJsonNavigator nav, RemoteSession _)
    : currentMenu = Menu.decode(nav.go('menuDeLaCantine'));

  static final definition = WidgetDefinition(
    type: .menuDeLaCantine,
    shouldCreate: (nav, _) =>
        nav.mGo('menuDeLaCantine')?.mGetL('listeRepas')?.notEmpty ?? false,
    create: MenuDeLaCantine.decode,
  );

  @override
  List<VisualIdMixin> get toStore => [...currentMenu.meals];
}
