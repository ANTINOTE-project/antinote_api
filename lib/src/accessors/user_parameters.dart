import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/tab.dart';
import 'package:antinote/src/models/user/authorizations.dart';
import 'package:antinote/src/models/user/parameters.dart';
import 'package:antinote/src/models/user/resource.dart';

class UserParametersAccessor
    extends StatefulAccessor<UserParameters, PronoteSession> {
  const UserParametersAccessor();

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
        .future;
  }

  @override
  FutureOr<PronoteSession> collectState(PronoteSession session) => session;

  @override
  FutureOr<UserParameters> interpret(
    MapJsonNavigator nav,
    PronoteSession state,
  ) {
    final dataNav = nav.getM(state.stack.vocab.data);
    final filesNav = nav.mGetL<String>('fichiers');

    List<MapJsonNavigator> resources = [
      ...?dataNav.go('ressource').mGetLM('listeRessources'),
    ];

    if (resources.isEmpty) {
      resources.add(dataNav.getM('ressource'));
    }

    return UserParameters(
      id: dataNav.go('ressource').get('N'),
      type: dataNav.go('ressource').get('G'),
      name: dataNav.go('ressource').get('L'),
      resources: resources.mapL((e) => e.asUserResource(filesNav ?? [])),
      authorizations: dataNav.asUserAuthorizations(),
      tabs: dataNav.getLM('listeOnglets').mapL((e) => e.asTab()),
      hiddenTabIds: dataNav.getL<int>('listeOngletsInvisibles'),
      notificationTabIds: dataNav.getL<int>('listeOngletsNotification'),
    );
  }

  @override
  List<VisualIdMixin> store(UserParameters result) => [result];
}
