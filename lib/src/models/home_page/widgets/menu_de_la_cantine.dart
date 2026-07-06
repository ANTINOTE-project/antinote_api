part of '../widget.dart';

class MenuDeLaCantine extends HomePageWidget {
  final Menu currentMenu;

  const MenuDeLaCantine({required this.currentMenu});

  @override
  HomePageWidgetType get widgetId => HomePageWidgetType.menuDeLaCantine;

  MenuDeLaCantine.decode(MapJsonNavigator nav, RemoteSession _)
    : currentMenu = Menu.decode(nav.go('menuDeLaCantine'));

  static final definition = WidgetDefinition(
    type: HomePageWidgetType.menuDeLaCantine,
    shouldCreate: (nav, _) =>
        nav.mGo('menuDeLaCantine')?.mGetL('listeRepas')?.notEmpty ?? false,
    create: MenuDeLaCantine.decode,
  );

  @override
  List<VisualIdMixin> get toStore => [...currentMenu.meals];
}
