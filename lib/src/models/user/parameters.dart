import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/disconnection_period_data.dart';
import 'package:antinote/src/models/tab.dart';
import 'package:antinote/src/models/user/authorizations.dart';
import 'package:antinote/src/models/user/resource.dart';

final class const UserParameters({
  required final String id,
  required final int type,
  required final String name,

  required final UserAuthorizations authorizations,
  required final OffTimeParameters? offTimeParameters,
  required final List<UserResource> resources,

  required final List<Tab> tabs,
  required final List<int> hiddenTabIds,
  required final List<int> notificationTabIds,
}) with VisualIdMixin {
  factory decode(RemoteSession session, Map<String, dynamic> nav) {
    List<Map<String, dynamic>> resources = [
      ...?nav.go('ressource').mGetLM('listeRessources'),
    ];

    if (resources.isEmpty) {
      resources.add(nav.getM('ressource'));
    }

    return .new(
      id: nav.go('ressource').get('N'),
      type: nav.go('ressource').get('G'),
      name: nav.go('ressource').get('L'),
      resources: resources.mapL((e) => .decode(e)),
      authorizations: .decode(nav),
      offTimeParameters: nav.has('infosDroitDeconnexion')
          ? .decode(session, nav.getM('infosDroitDeconnexion'))
          : null,
      // TODO: Add establishment data (listeInformationsEtablissements)
      tabs: nav.getLM('listeOnglets').mapL((e) => .decode(e)),
      hiddenTabIds: nav.getL<int>('listeOngletsInvisibles'),
      notificationTabIds: nav.getL<int>('listeOngletsNotification'),
    );
  }

  @override
  CacheType? get cacheType => .UNIQUE;

  @override
  SerialObjectId? get overrideSerialId => .userParameters;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {}

  bool hasAccessToTab(int tab) {
    return tabs.any((element) => element.hasTab(tab));
  }

  @override
  List<VisualNavigator> get toStore => [
    if (offTimeParameters != null)
      .go(offTimeParameters!, field: 'infosDroitDeconnexion'),
  ];
}
