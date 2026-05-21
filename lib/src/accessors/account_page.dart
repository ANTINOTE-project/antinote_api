import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/account/page.dart';

final class AccountPageAccessor extends StatelessAccessor<AccountPage> {
  const AccountPageAccessor();

  @override
  FutureOr<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) {
    return stack
        .post(
          Call.function(
            cancellationSignal: cancellationSignal,
            dataSec: {},
            name: 'PageInfosPerso',
          ),
        )
        .resultCompleter
        .future
        .thenField(stack.vocab.data);
  }

  @override
  FutureOr<AccountPage> interpretStateless(MapJsonNavigator<dynamic> nav) =>
      nav.asAccountPage();

  @override
  List<VisualIdMixin> store(AccountPage result) => [];
}
