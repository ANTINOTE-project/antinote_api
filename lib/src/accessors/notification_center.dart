import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/notification/center.dart';

class NotificationCenterAccessor extends StatelessAccessor<NotificationCenter> {
  @override
  bool get exclusiveFriendly => true;

  @override
  FutureOr<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) async {
    return stack
        .post(
          Call.function(
            name: 'CentraleNotifications',
            dataSec: {},
            cancellationSignal: cancellationSignal,
          ),
        )
        .resultCompleter
        .future
        .thenField(stack.vocab.data);
  }

  @override
  FutureOr<NotificationCenter> interpretStateless(MapJsonNavigator nav) {
    return nav.asNotificationCenter();
  }

  @override
  List<VisualIdMixin> store(NotificationCenter result) => [];
}
