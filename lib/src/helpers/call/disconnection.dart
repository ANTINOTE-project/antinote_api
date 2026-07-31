part of 'call.dart';

final class _DisconnectionCall extends Call {
  // dart format off
  @override get callType => 'appeldeconnexion';
  @override get orderBehavior => OrderBehavior.communication;
  @override get appendOrderToUrl => true;
  @override get addSignature => false;
  @override get dataSec => {};
  @override final Completer<void> cancellationSignal;
  @override get name => 'Disconnect';
  @override final Completer<Map<String, dynamic>> resultCompleter = Completer();
  @override final bool waitForResponse;
  // dart format on

  @override
  Uri buildUri(NetworkStack stack, String order) => stack.baseUrl.replace(
    pathSegments: [
      ...stack.baseUrl.pathSegments,
      callType,
      order,
      DateTime.now().millisecondsSinceEpoch.toString(),
    ],
  );

  @override
  HttpClientRequest serialize(
    NetworkStack stack,
    HttpClientRequest req,
    String orderId, {
    bool debugMode = false,
  }) {
    final rawJson = RemoteJsonEncoder(
      data: {
        stack.vocab.orderNumber: orderId,
        stack.vocab.sessionNumber: stack.sessionId,
      },
    ).encode();

    if (debugMode) {
      stack.log.fine('Sending:');
      stack.log.fine(rawJson);
    }

    req.headers.add(HttpHeaders.contentTypeHeader, 'application/json');

    req.add(utf8.encode(rawJson));
    cancellationSignal.future.then((value) => req.abort());

    return req;
  }

  _DisconnectionCall({
    this.waitForResponse = true,
    required Completer<void>? cancellationSignal,
  }) : cancellationSignal = cancellationSignal ?? Completer();
}
