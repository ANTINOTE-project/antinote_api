import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';

final class const NavigationAccessor({
  required final int previousTabId,
  required final int currentTabId,
}) extends StatelessAccessor<void> {
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
            name: 'Navigation',
            dataSec: {
              session.stack.vocab.data: {
                'onglet': currentTabId,
                'ongletPrec': previousTabId,
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .resultCompleter
        .future;
  }

  @override
  FutureOr<void> interpretStateless(MapJsonNavigator nav) {}

  @override
  List<VisualIdMixin> store(void result) => [];
}
