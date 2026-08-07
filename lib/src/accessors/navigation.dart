import 'dart:async';

import 'package:antinote_api/src/accessors/accessors.dart';
import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/session.dart';

final class const NavigationAccessor({
  required final int previousTabId,
  required final int currentTabId,
}) extends Accessor<void> {
  @override
  bool get exclusiveFriendly => true;

  @override
  // Would be recursive if non-null.
  int? get page => null;

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
  FutureOr<void> interpret(Map<String, dynamic> nav, RemoteSession session) {}

  @override
  List<VisualNavigator> store(void result) => [];
}
