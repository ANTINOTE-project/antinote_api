import 'dart:async';

import 'package:antinote_api/src/accessors/accessors.dart';
import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/call/call.dart';
import 'package:antinote_api/src/helpers/session.dart';
import 'package:antinote_api/src/models/account/page.dart';

final class const AccountPageAccessor() extends Accessor<AccountPage> {
  @override
  bool get exclusiveFriendly => true;

  @override
  int? get page => 49;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
            cancellationSignal: cancellationSignal,
            dataSec: {},
            name: 'PageInfosPerso',
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<AccountPage> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) => .decode(nav);

  @override
  List<VisualNavigator> store(AccountPage result) => [];
}
