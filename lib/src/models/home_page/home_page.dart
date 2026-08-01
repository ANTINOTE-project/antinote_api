import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/disconnection_period_data.dart';
import 'package:antinote/src/models/home_page/widget.dart';

final class const HomePage({
  required final List<HomePageWidget> widgets,
  required final bool duringDisconnectionPeriod,
  required final DisconnectionPeriodData? disconnectionPeriodData,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav, RemoteSession session) {
    final elements = widgetDefinitions
        .where((element) => element.shouldCreate(nav, session))
        .map((e) => e.create(nav, session))
        .toList(growable: true);

    final offData = nav.has('infosDroitDeconnexion')
        ? DisconnectionPeriodData.decode(
            session,
            nav.go('infosDroitDeconnexion'),
          )
        : null;

    return HomePage(
      widgets: elements,
      duringDisconnectionPeriod: nav.getB('estDansUnePeriodeDeDeconnexion'),
      disconnectionPeriodData: offData,
    );
  }

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() => throw UnimplementedError();

  @override
  List<VisualNavigator> get toStore => [
    if (disconnectionPeriodData != null)
      .go(disconnectionPeriodData!, field: 'infosDroitDeconnexion'),

    for (final widget in widgets) ...widget.toStore,
  ];
}
