import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/disconnection_period_data.dart';
import 'package:antinote/src/models/home_page/widget.dart';

final class const HomePage({
  required final List<HomePageWidget> widgets,
  required final bool duringOffTime,
  required final OffTimeParameters? offTimeParameters,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav, RemoteSession session) {
    final elements = widgetDefinitions
        .where((element) => element.shouldCreate(nav, session))
        .map((e) => e.create(nav, session))
        .toList(growable: true);

    final offData = nav.has('infosDroitDeconnexion')
        ? OffTimeParameters.decode(session, nav.go('infosDroitDeconnexion'))
        : null;

    return HomePage(
      widgets: elements,
      duringOffTime: nav.getB('estDansUnePeriodeDeDeconnexion'),
      offTimeParameters: offData,
    );
  }

  @override
  CacheType? get cacheType => null;

  @override
  Iterable<Uint8List?> collectVisualIdData() => throw UnimplementedError();

  @override
  List<VisualNavigator> get toStore => [
    if (offTimeParameters != null)
      .go(offTimeParameters!, field: 'infosDroitDeconnexion'),

    for (final widget in widgets) ...widget.toStore,
  ];
}
