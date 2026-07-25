import 'dart:async';

import '../../antinote.dart';

final class PollingAccessor() extends StatelessAccessor<MapJsonNavigator> {
  @override
  bool get exclusiveFriendly => true;

  @override
  Future<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          Call.polling(
            name: 'polling',
            dataSec: {},
            waitForResponse: false,
            cancellationSignal: cancellationSignal,
          ),
        )
        .resultCompleter
        .future;
  }

  @override
  FutureOr<MapJsonNavigator> interpretStateless(MapJsonNavigator nav) async {
    return nav;
  }

  @override
  List<VisualIdMixin> store(MapJsonNavigator result) => [];
}
