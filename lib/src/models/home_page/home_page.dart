import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/models/home_page/widget.dart';

final class HomePage {
  final List<HomePageWidget> widgets;

  const HomePage({required this.widgets});

  factory HomePage.decode(MapJsonNavigator nav, RemoteSession session) {
    final elements = widgetDefinitions
        .where((element) => element.shouldCreate(nav, session))
        .map((e) => e.create(nav, session))
        .toList(growable: true);

    return HomePage(widgets: elements);
  }
}
