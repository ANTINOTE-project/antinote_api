import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/tab.dart';
import 'package:antinote/src/models/user/authorizations.dart';
import 'package:antinote/src/models/user/parameters.dart';
import 'package:antinote/src/models/user/resource.dart';

class UserParametersAccessor extends StatelessAccessor<UserParameters> {
  const UserParametersAccessor();

  @override
  bool get exclusiveFriendly => true;

  @override
  Future<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) {
    return stack
        .post(
          Call.function(
            name: 'ParametresUtilisateur',
            dataSec: {},
            cancellationSignal: cancellationSignal,
          ),
        )
        .resultCompleter
        .future
        .thenField(stack.vocab.data);
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
      resources: resources.mapL((e) => e.asUserResource()),
      authorizations: nav.asUserAuthorizations(),
      tabs: nav.getLM('listeOnglets').mapL((e) => e.asTab()),
      hiddenTabIds: nav.getL<int>('listeOngletsInvisibles'),
      notificationTabIds: nav.getL<int>('listeOngletsNotification'),
    );
  }

  @override
  List<VisualIdMixin> store(UserParameters result) => [result];
}
