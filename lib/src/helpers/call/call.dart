library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:antinote/src/helpers/enum_id.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:http/http.dart';

part 'disconnection.dart';
part 'function.dart';
part 'polling.dart';
part 'upload.dart';

sealed class Call {
  // dart format off
  String get name;
  Map<String, dynamic> get dataSec;
  bool get waitForResponse;
  bool get addSignature;
  Completer<void> get cancellationSignal;
  Completer<Map<String, dynamic>> get resultCompleter;
  String get callType;
  bool get appendOrderToUrl;
  OrderBehavior get orderBehavior;
  // dart format on

  const Call();

  factory Call.function({
    bool addSignature,
    required Completer<void>? cancellationSignal,
    required Map<String, dynamic> dataSec,
    required String name,
    bool waitForResponse,
  }) = _FunctionCall;

  factory Call.disconnection({
    required Completer<void>? cancellationSignal,
    bool waitForResponse,
  }) = _DisconnectionCall;

  factory Call.polling({
    bool addSignature,
    Completer<void>? cancellationSignal,
    required Map<String, dynamic> dataSec,
    required String name,
    bool waitForResponse,
  }) = _PollingCall;

  factory Call.upload({
    required Completer<void>? cancellationSignal,
    required UploadCallData data,
    required String name,
    bool waitForResponse,
  }) = _FileUploadCall;

  // https://demo.index-education.net/pronote/appelfonction/6/6855817/3fa959b13967e0ef176069e01e23c8d7
  // https://demo.index-education.net/pronote/appelpolling/6/6855817/37c4058a2b301f2c4ed427c217d99915
  // https://demo.index-education.net/pronote/uploadfilesession/6/6855817
  Uri buildUri(NetworkStack stack, String order) => stack.baseUrl.replace(
    pathSegments: [
      ...stack.baseUrl.pathSegments,
      callType,
      stack.temporaryWorkspace.type.id.toString(),
      stack.sessionId.toString(),
      if (appendOrderToUrl) order,
    ],
  );

  Object? _helpEncode(Object? unencodable) {
    if (unencodable is EnumId) {
      return unencodable.id;
    }

    return null;
  }

  FutureOr<HttpClientRequest> serialize(
    NetworkStack stack,
    HttpClientRequest req,
    String orderId,
  ) {
    req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

    final rawJson = jsonEncode({
      stack.vocab.session: stack.sessionId,
      stack.vocab.orderNumber: orderId,
      stack.vocab.requestId: name,
      stack.vocab.secureData: deepMergeMaps(
        dataSec,
        addSignature
            ? {
                if (stack.clientSignature != null)
                  stack.vocab.signature: stack.clientSignature,
              }
            : {},
      ),
    }, toEncodable: _helpEncode);

    req.add(utf8.encode(rawJson));
    cancellationSignal.future.then((value) => req.abort());

    return req;
  }
}

final class OrderBehavior {
  final int initialValue;
  final int increment;
  final bool incrementBeforeCall;
  final bool incrementAfterCall;
  final String name;

  const OrderBehavior({
    required this.initialValue,
    required this.increment,
    required this.incrementBeforeCall,
    required this.incrementAfterCall,
    required this.name,
  });

  static const communication = OrderBehavior(
    initialValue: 0,
    increment: 1,
    incrementBeforeCall: true,
    incrementAfterCall: true,
    name: 'communication',
  );
  static const poll = OrderBehavior(
    initialValue: -1,
    increment: -1,
    incrementBeforeCall: false,
    incrementAfterCall: true,
    name: 'polling',
  );
  static const idCreation = OrderBehavior(
    initialValue: -1000,
    increment: -1,
    incrementBeforeCall: false,
    incrementAfterCall: false,
    name: 'new_ids',
  );

  static OrderBehavior fileUpload(String category) => OrderBehavior(
    initialValue: 0,
    increment: 1,
    incrementBeforeCall: false,
    incrementAfterCall: false,
    name: '${category}_file_upload',
  );
}

extension ThenDataCall on Call {
  Future<Map<String, dynamic>> thenField(String field) {
    return resultCompleter.future.thenField(field);
  }
}

extension ThenDataMap on Future<Map<String, dynamic>> {
  Future<Map<String, dynamic>> thenField(String field) {
    return then((e) => e[field]);
  }
}

Map<String, dynamic> propertyCaseInsensitive(String name, dynamic value) {
  return <String, dynamic>{
    name: value,
    name[0].toUpperCase() + name.substring(1): value,
  };
}
