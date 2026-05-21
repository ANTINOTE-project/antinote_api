part of '../widget.dart';

class TravailAFaire extends HomePageWidget {
  final List<Homework> homeworks;

  const TravailAFaire({required this.homeworks});

  @override
  HomePageWidgetType get widgetId => HomePageWidgetType.travailAFaire;

  TravailAFaire.decode(MapJsonNavigator nav, PronoteSession _)
    : homeworks = nav
          .go('travailAFaire')
          .getLM('listeTAF')
          .mapL((e) => e.asHomework());

  static final definition = WidgetDefinition(
    type: HomePageWidgetType.travailAFaire,
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
