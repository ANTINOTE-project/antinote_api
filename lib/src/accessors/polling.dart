import 'dart:async';


import '../../antinote.dart';

class PollingAccessor extends StatelessAccessor<MapJsonNavigator> {
  @override
  Future<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) {
    return stack
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

  const PollingAccessor();
}
