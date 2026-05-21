part of 'call.dart';

final class _PollingCall extends Call {
  // dart format off
  @override get callType => 'appelpolling';
  @override get orderBehavior => OrderBehavior.poll;
  @override get appendOrderToUrl => true;
  @override final Completer<void> cancellationSignal;
  @override final bool addSignature;
  @override final Map<String, dynamic> dataSec;
  @override final String name;
  @override final Completer<Map<String, dynamic>> resultCompleter = Completer();
  @override final bool waitForResponse;
  // dart format on

  _PollingCall({
    required this.name,
    required this.dataSec,
    this.waitForResponse = true,
    this.addSignature = false,
    Completer<void>? cancellationSignal,
  }) : cancellationSignal = cancellationSignal ?? Completer();
}
