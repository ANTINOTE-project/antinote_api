import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:antinote/antinote.dart';
import 'package:antinote/src/helpers/api_properties.dart';
import 'package:antinote/src/helpers/json_codec.dart';
import 'package:http/http.dart';
import 'package:version/version.dart';

export 'call/call.dart';

class NetworkStack {
  NetworkStack({
    required this.cookies,
    required this.vocab,
    required this.crypto,
    required this.baseUrl,
    this.temporaryWorkspace = Workspace.commonMobile,
    required this.pronoteVersion,
    required this.demo,
    required this.rsaFromConstants,
    required this.skipEncryption,
    required this.skipCompression,
    required this.http,
    required this.poll,
    required this.sessionId,
    required this.tokenId,
    required this.tokenKey,
  });

  static Future<NetworkStack> restore(SerializedNetworkStack serialized) async {
    final pnVersion = Version.parse(serialized.instanceVersion);

    final stack = NetworkStack(
      cookies: serialized.cookies.mapL(
        (e) => Cookie.fromSetCookieValue(e),
        true,
      ),
      vocab: ApiVocabulary.forVersion(pnVersion),
      crypto: await Crypto.restore(serialized.crypto),
      baseUrl: Uri.parse(serialized.baseUrl),
      // Maybe add back the check to remove query part of URL?
      temporaryWorkspace: Workspace.restore(serialized.tempWorkspace),
      pronoteVersion: pnVersion,
      demo: serialized.demo,
      rsaFromConstants: serialized.rsaFromConstants,
      skipEncryption: serialized.skipEncryption,
      skipCompression: serialized.skipCompression,
      http: serialized.http,
      poll: serialized.poll,
      sessionId: serialized.sessionId,
      tokenId: serialized.tokenId,
      tokenKey: serialized.tokenKey,
    );

    stack.username = serialized.username;

    if (serialized.hasClientSignature()) {
      stack.updateClientSignature(jsonDecode(serialized.clientSignature));
    }

    if (serialized.hasServerSignature()) {
      stack.updateServerSignature(jsonDecode(serialized.serverSignature));
    }

    stack._orders.addAll(serialized.orders);

    return stack;
  }

  SerializedNetworkStack serialize() {
    return SerializedNetworkStack(
      crypto: crypto.serialize(),
      instanceVersion: pronoteVersion.toString(),
      baseUrl: baseUrl.toString(),
      cookies: cookies.map((e) => e.toString()),
      tempWorkspace: temporaryWorkspace.serialize(),
      demo: demo,
      rsaFromConstants: rsaFromConstants,
      skipEncryption: skipEncryption,
      skipCompression: skipCompression,
      http: http,
      poll: poll,
      username: username,
      sessionId: sessionId,
      tokenId: tokenId,
      tokenKey: tokenKey,
      clientSignature: clientSignature == null
          ? null
          : jsonEncode(clientSignature!),
      serverSignature: serverSignature == null
          ? null
          : jsonEncode(serverSignature!),
      orders: _orders.entries,
    );
  }

  // Server state
  /// Gives often-used field names by PRONOTE which differ in name but not in
  /// behavior between versions. We adapt it depending on the version given by
  /// the server to **try** to ensure backwards-compatibility in that regard.
  final ApiVocabulary vocab;

  /// The base URL of the PRONOTE instance this session is linked to. From it,
  /// every query URL is formed.
  final Uri baseUrl;

  /// The version of the PRONOTE instance the [baseUrl] points to.
  final Version pronoteVersion;

  /// Whether the PRONOTE instance the [baseUrl] points to is a
  /// demonstration instance.
  final bool demo;

  /// Whether the PRONOTE instance the [baseUrl] points to gives custom
  /// RSA constants (this is deprecated in PRONOTE.)
  final bool rsaFromConstants;

  /// Whether to skip encryption. Encryption is enabled when the SSL certificate
  /// of the instance is invalid (expired, missing...)
  final bool skipEncryption;

  /// Whether to skip compression. Compression is deprecated but essentially
  /// GZip-compresses requests sent to the PRONOTE instance.
  final bool skipCompression;

  /// Documentation N/A.
  final bool http;

  /// Whether polling is enabled. This is used to keep alive a session and
  /// receive configuration changes from the instance without technically
  /// sending a request.
  final bool poll;

  // Client state
  /// The client used to send calls and requests.
  final HttpClient client = HttpClient();

  // TODO: Make cookies something to send in calls instead of always sending
  // TODO: them with every request.
  /// The cookies to send to the client.
  ///
  /// This is used mainly on CAS login.
  final List<Cookie> cookies;

  /// This should not be used to graphically show its label, it is only there so
  /// that [Call.buildUri] is valid before FonctionParametres.
  ///
  /// So, the type and the path segment are always valid, the label is not.
  final Workspace temporaryWorkspace;

  /// The username of the user of the session.
  late final String username;

  /// The ID of the session. Changes for each login.
  final int sessionId;

  /// The "Token ID" is some form of encrypted username used on CAS login.
  final String? tokenId;

  /// The "Token Key" is some form of password used on CAS login.
  final String? tokenKey;

  /// The global signature is appended mainly to function calls after login
  /// which is used by PRONOTE to know some kinds of actions taken by the client
  /// (resource swaps, page navigation...)
  Map<String, dynamic>? get clientSignature => _clientSignature;
  Map<String, dynamic>? _clientSignature;

  /// Updates [clientSignature] by merging the existing one with the new data.
  void updateClientSignature(
    Map<String, dynamic> newSignature, {
    bool deepMerge = true,
  }) {
    _clientSignature = deepMergeMaps(
      newSignature,
      clientSignature ?? {},
      mergeInnerMaps: deepMerge,
    );
  }

  final StreamController<Map<String, dynamic>>
  _serverSignatureStreamController = StreamController.broadcast();

  /// A stream sending the new server signature each time it is updated.
  Stream<Map<String, dynamic>> get serverSignatureStream =>
      _serverSignatureStreamController.stream;

  /// The current configuration asked by the PRONOTE server.
  Map<String, dynamic>? get serverSignature => _serverSignature;
  Map<String, dynamic>? _serverSignature;

  /// Updates [serverSignature] by merging the existing one with the new data.
  void updateServerSignature(
    Map<String, dynamic> newSignature, {
    bool deepMerge = true,
  }) {
    _serverSignature = deepMergeMaps(
      newSignature,
      serverSignature ?? {},
      mergeInnerMaps: deepMerge,
    );

    _serverSignatureStreamController.add(_serverSignature!);
  }

  /// When an Android device is asleep, it blocks by default all network-related
  /// requests, using this to pause network requests (which will get aborted
  /// instantly) is the recommended way to do it.
  Completer<void> networkPause = Completer()..complete();

  /// The orders map contains the individual orders for each request type
  /// (namely polling and communications.)
  final Map<String, int> _orders = {};

  /// Advances the order number by one step depending on the
  /// [OrderBehavior.increment].
  void nextOrder(OrderBehavior behavior) {
    _orders[behavior.name] =
        (_orders[behavior.name] ?? behavior.initialValue) + behavior.increment;
  }

  /// Walks back the order number by one step depending on the
  /// [OrderBehavior.increment].
  void previousOrder(OrderBehavior behavior) {
    _orders[behavior.name] =
        (_orders[behavior.name] ?? behavior.initialValue) - behavior.increment;
  }

  /// Gives the current order number which describes [behavior].
  int order(OrderBehavior behavior) {
    return _orders[behavior.name] ?? behavior.initialValue;
  }

  final Queue<Call> _callsQueue = Queue();

  /// Cryptographic storage for utils functions and session keys.
  final Crypto crypto;

  /// Sends a request. Currently, no request body can be added to the request.
  Future<HttpClientResponse> createRequest(
    String method,
    Uri url, {
    List<Cookie> cookies = const [],
  }) async {
    final request = await client.openUrl(method, url);
    request.cookies.addAll(cookies);

    return await request.close();
  }

  /// The "executor" ensures no request is sent before another one gets its
  /// response, as PRONOTE requires.
  Future<void> _startExecutor() async {
    while (_callsQueue.isNotEmpty) {
      final call = _callsQueue.first;

      if (call.cancellationSignal.isCompleted ||
          call.resultCompleter.isCompleted) {
        _callsQueue.removeFirst();
        continue;
      }

      final result = _sendCall(call);
      if (call.waitForResponse) {
        final Map<String, dynamic> completed;
        try {
          completed = await result;
          call.resultCompleter.complete(completed);
        } catch (e) {
          call.resultCompleter.completeError(e);
        }
      } else {
        call.resultCompleter.complete(result);
      }

      _callsQueue.removeFirst();
    }
  }

  Future<Map<String, dynamic>> _sendCall(Call call) async {
    final payload = await _processCall(call);

    await networkPause.future;

    print(
      'Calling   ${call.name} (order=${order(call.orderBehavior)}) '
      'at ${payload.uri.toString()}',
    );

    final List<PronoteJsonDecoder> decoders = [];

    late final Map<String, dynamic> response;

    try {
      final req = await call.serialize(
        this,
        await client.postUrl(payload.uri)
          ..cookies.addAll(cookies),
        payload.orderId,
      );
      final res = await req.close();
      var rawResponse = await res.transform(utf8.decoder).join();

      if (rawResponse.isEmpty) rawResponse = '{}';

      // Don't ask me why I made this so complicated. TODO
      final decoder = PronoteJsonDecoder(data: rawResponse);
      decoders.add(decoder);
      response = decoder.decode();
    } on RequestAbortedException {
      print(
        'Aborted   ${call.name} (estimated order=${order(call.orderBehavior)}) '
        'at ${payload.uri.toString()}',
      );

      return {};
    } on IOException catch (e) {
      print(
        'Failed    ${call.name} (estimated order=${order(call.orderBehavior)}) '
        'at ${payload.uri.toString()} (${e.runtimeType} '
        '${e is HttpException ? e.message : 'no recognizable message'})',
      );

      rethrow;
    }

    if (call.orderBehavior.incrementAfterCall) {
      nextOrder(call.orderBehavior);
    }

    final respOrderNumber = response[vocab.orderNumber];
    if (respOrderNumber is String) {
      late final String? exactOrder;
      try {
        exactOrder = utf8.decode(
          await crypto.aesDecrypt(respOrderNumber.fromHex()),
        );
      } catch (e) {
        try {
          exactOrder = utf8.decode(
            await crypto.aesDecrypt(
              respOrderNumber.fromHex(),
              ivMode: IvMode.zeros,
            ),
          );
          print('Had to remove IV to decrypt order from request!');
        } catch (e) {
          exactOrder = null;
          print(
            'Could not decrypt order although it is present in the response...',
          );
        }
      }
      print(
        'Receiving ${call.name} '
        '(${exactOrder == null ? 'unsuccessfully estimated ' : ''}'
        'order=${exactOrder ?? order(call.orderBehavior)}) '
        'at ${payload.uri.toString()}',
      );
    } else {
      print(
        'Receiving ${call.name} (estimated order=${order(call.orderBehavior)}) '
        'at ${payload.uri.toString()}',
      );
    }

    if (response.containsKey('Erreur')) {
      final error = response.getM('Erreur');
      throw SessionException(
        title: error.get('Titre'),
        message: error.get('Message'),
        type: error.get('G'),
      );
    }

    final rawDataSources = [
      ?response[vocab.secureData],
      ?response[vocab.nonSecureData],
    ];

    // Unusual requests (such as file uploads) don't have secure/nonSecureData.
    if (rawDataSources.isEmpty) rawDataSources.add(response);

    Map<String, dynamic> data = {};
    for (var dataSource in rawDataSources) {
      if (dataSource is String) {
        final decoder = PronoteJsonDecoder(data: dataSource);
        decoders.add(decoder);
        dataSource = decoder.decode();
      }
      assert(dataSource is Map<String, dynamic>);

      data = deepMergeMaps(data, dataSource);
    }

    if (decoders.isNotEmpty) {
      final nav = data;
      for (final decoder in decoders) {
        decoder.resolveAll(nav);
      }
    }

    if (data.containsKey(vocab.signature)) {
      print('${call.name} had signature, propagating...');
      updateServerSignature(data[vocab.signature]);
    }

    return data;
  }

  /// Adds a request for the executor to execute.
  ///
  /// This is the main way anyone should send anything to PRONOTE (excepted
  /// special endpoints which do not use any complicated logic.)
  Call post(Call call) {
    final executorRunning = _callsQueue.isNotEmpty;
    _callsQueue.add(call);

    if (!executorRunning) _startExecutor();

    return call;
  }

  Future<({Uri uri, String orderId})> _processCall(Call call) async {
    if (call.orderBehavior.incrementBeforeCall) {
      nextOrder(call.orderBehavior);
    }
    final createdOrder = await getEncryptedOrder(
      call.orderBehavior,
      forceNullIv: order(call.orderBehavior) == 1,
    );

    final callUrl = call.buildUri(this, createdOrder);

    if (!skipCompression) {
      throw UnimplementedError('TODO: Add compression');
    }

    if (!skipEncryption) {
      throw UnimplementedError('TODO: Add encryption');
    }

    return (uri: callUrl, orderId: createdOrder);
  }

  Future<String> getEncryptedOrder(
    OrderBehavior behavior, {
    required bool forceNullIv,
  }) async {
    return (await crypto.aesEncrypt(
      Uint8List.fromList(order(behavior).toString().codeUnits),
      ivMode: forceNullIv ? IvMode.zeros : IvMode.real,
    )).toHex();
  }

  /// Util function which is used in the instance parameters call.
  String generateIvUuid() {
    return base64Encode(
      rsaFromConstants && !http
          ? crypto.aesIv
          : crypto.rsaEncrypt(crypto.aesIv),
    );
  }
}
