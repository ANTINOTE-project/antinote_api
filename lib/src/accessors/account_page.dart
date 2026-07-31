import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/call/call.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/account/page.dart';

final class const AccountPageAccessor() extends StatelessAccessor<AccountPage> {
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
        .resultCompleter
        .future
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<AccountPage> interpretStateless(Map<String, dynamic> nav) =>
      .decode(nav);

  @override
  List<VisualIdMixin> store(AccountPage result) => [];
}
