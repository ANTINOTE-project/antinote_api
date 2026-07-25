import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/user/parameters.dart';

final class const UserParametersAccessor()
    extends StatelessAccessor<UserParameters> {
  @override
  bool get exclusiveFriendly => true;

  @override
  Future<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
            name: 'ParametresUtilisateur',
            dataSec: {},
            cancellationSignal: cancellationSignal,
          ),
        )
        .resultCompleter
        .future
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<UserParameters> interpretStateless(MapJsonNavigator nav) {
    List<MapJsonNavigator> resources = [
      ...?nav.go('ressource').mGetLM('listeRessources'),
    ];

    if (resources.isEmpty) {
      resources.add(nav.getM('ressource'));
    }

    return UserParameters(
      id: nav.go('ressource').get('N'),
      type: nav.go('ressource').get('G'),
      name: nav.go('ressource').get('L'),
      resources: resources.mapL((e) => .decode(e)),
      authorizations: .decode(nav),
      tabs: nav.getLM('listeOnglets').mapL((e) => .decode(e)),
      hiddenTabIds: nav.getL<int>('listeOngletsInvisibles'),
      notificationTabIds: nav.getL<int>('listeOngletsNotification'),
    );
  }

  @override
  List<VisualIdMixin> store(UserParameters result) => [result];
}
