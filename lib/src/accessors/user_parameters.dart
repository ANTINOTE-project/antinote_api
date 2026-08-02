import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/models/user/parameters.dart';

final class const UserParametersAccessor() extends Accessor<UserParameters> {
  @override
  bool get exclusiveFriendly => true;

  @override
  int? get page => null;

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
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<UserParameters> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) => .decode(session, nav);

  @override
  List<VisualNavigator> store(UserParameters result) => [.stay(result)];
}
