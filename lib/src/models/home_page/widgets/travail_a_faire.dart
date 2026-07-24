part of '../widget.dart';

final class const TravailAFaire({required final List<Homework> homeworks})
    extends HomePageWidget {
  factory decode(MapJsonNavigator nav, RemoteSession _) => .new(
    homeworks: nav
        .go('travailAFaire')
        .getLM('listeTAF')
        .mapL((e) => .decode(e)),
  );

  static HomePageModule module() =>
      HomePageModule(widget: .travailAFaire, data: (session) => {});

  @override
  HomePageWidgetType get widgetId => .travailAFaire;

  static final definition = WidgetDefinition(
    type: .travailAFaire,
    shouldCreate: (nav, session) {
      if (session.instance.workspace.type.categories.contains(
        WorkspaceCategory.forPrimary,
      )) {
        return false;
      }

      return nav.mGo('travailAFaire')?.mGetL('listeTAF')?.isNotEmpty ?? false;
    },
    create: TravailAFaire.decode,
  );

  @override
  List<VisualIdMixin> get toStore => homeworks;
}
