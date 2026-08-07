import 'dart:async';

import 'package:antinote_api/antinote_api.dart';

final class const PollingAccessor() extends Accessor<Map<String, dynamic>> {
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
          .polling(
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
  FutureOr<Map<String, dynamic>> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) async {
    return nav;
  }

  @override
  List<VisualNavigator> store(Map<String, dynamic> result) => [];
}
