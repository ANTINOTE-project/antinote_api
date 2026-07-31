part of '../widget.dart';

final class const MenuDeLaCantine({required final Menu currentMenu})
    extends HomePageWidget {
  factory decode(Map<String, dynamic> nav, RemoteSession _) =>
      .new(currentMenu: Menu.decode(nav.go('menuDeLaCantine')));

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
  List<VisualIdMixin> get toStore => [...currentMenu.meals];
}
