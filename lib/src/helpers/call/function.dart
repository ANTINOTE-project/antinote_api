part of 'call.dart';

final class _FunctionCall extends Call {
  // dart format off
  @override get callType => 'appelfonction';
  @override get orderBehavior => OrderBehavior.communication;
  @override get appendOrderToUrl => true;
  @override final Completer<void> cancellationSignal;
  @override final bool addSignature;
  @override final Map<String, dynamic> dataSec;
  @override final String name;
  @override final Completer<Map<String, dynamic>> resultCompleter = Completer();
  @override final bool waitForResponse;
  // dart format on

  _FunctionCall({
    required this.name,
    required this.dataSec,
    this.waitForResponse = true,
    this.addSignature = true,
    required Completer<void>? cancellationSignal,
  }) : cancellationSignal = cancellationSignal ?? Completer();
}
