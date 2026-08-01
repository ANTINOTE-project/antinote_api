import 'dart:async';

import 'package:antinote/antinote.dart';

final class const PollingAccessor()
    extends StatelessAccessor<Map<String, dynamic>> {
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
  FutureOr<Map<String, dynamic>> interpretStateless(
    Map<String, dynamic> nav,
  ) async {
    return nav;
  }

  @override
  List<VisualNavigator> store(Map<String, dynamic> result) => [];
}
