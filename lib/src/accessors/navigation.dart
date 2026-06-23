import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/visual_id.dart';

class NavigationAccessor extends StatelessAccessor<void> {
  final int previousTabId;
  final int currentTabId;

  const NavigationAccessor({
    required this.previousTabId,
    required this.currentTabId,
  });

  @override
  Future<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) {
    return stack
        .post(
          Call.function(
            name: 'Navigation',
            dataSec: {
              stack.vocab.data: {
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
