import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';

class NavigationAccessor extends StatelessAccessor<void> {
  final int previousTabId;
  final int currentTabId;

  const NavigationAccessor({
    required this.previousTabId,
    required this.currentTabId,
  });

  @override
  bool get exclusiveFriendly => true;

  @override
  Future<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          Call.function(
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
