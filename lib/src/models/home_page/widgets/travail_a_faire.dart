part of '../widget.dart';

final class const TravailAFaire({required final List<Homework> homeworks})
    extends HomePageWidget {
  factory decode(Map<String, dynamic> nav, RemoteSession _) => .new(
    homeworks: nav
        .go('travailAFaire')
        .getLM('listeTAF')
        .mapL((e) => .decode(e)),
  );

  static HomePageModule module() => HomePageModule(
    widget: .travailAFaire,
    canQuerySpecifically: true,
    data: (session) => {},
  );

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
  List<VisualNavigator> get toStore => [
    for (final (index, homework) in homeworks.indexed)
      .new(
        exchanger: (nav) =>
            nav.go('travailAFaire').getLM('listeTAF').getM(index),
        value: homework,
      ),
  ];
}
