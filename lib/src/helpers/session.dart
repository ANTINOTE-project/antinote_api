import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:antinote/antinote.dart';
import 'package:antinote/src/helpers/api_properties.dart';
import 'package:antinote/src/helpers/json_codec.dart';
import 'package:antinote/src/models/authentication_response.dart';
import 'package:version/version.dart';

class RemoteSession {
  final NetworkStack stack;
  late final SerializableCacheStore serializableCache;
  final CacheStore cache = {for (final val in CacheType.values) val: {}};

  final SessionOptions options;

  static Future<RemoteSession> restore(
    SerializedSession serialized, {
    SessionOptions? options,
  }) async {
    final session = RemoteSession(
      stack: await NetworkStack.restore(serialized.stack),
      serializableCache: {
        for (final entry in serialized.cache) entry.type: entry.values,
      },
      options: options ?? SessionOptions.getDefault(),
    );

    await session._reconstructCache();

    return session;
  }

  static Future<RemoteSession> restoreBinary(
    Uint8List data, {
    SessionOptions? options,
  }) async => restore(SerializedSession.fromBuffer(data), options: options);

  static Future<RemoteSession> restoreJson(
    String data, {
    SessionOptions? options,
  }) async => restore(SerializedSession.fromJson(data), options: options);

  static final _instanceParametersKey = 'InstanceParameters'
      .visualIdData()
      .visualId;
  static final _userParametersKey = 'UserParameters'.visualIdData().visualId;
  static final _authenticationResponseKey = 'AuthenticationResponse'
      .visualIdData()
      .visualId;
  static final _challengeKey = 'Challenge'.visualIdData().visualId;

  // TODO: Make this self-contained
  Future<void> _reconstructCache() async {
    for (final MapEntry(key: cacheType, value: cached)
        in serializableCache.entries) {
      for (final MapEntry(key: visualId, value: rawContent) in cached.entries) {
        final content = RemoteJsonDecoder(data: rawContent).decode();

        final dynamic parsedValue;
        if (visualId == _instanceParametersKey) {
          final accessor = const InstanceParametersAccessor();
          parsedValue = await accessor.interpret(
            content,
            stack.temporaryWorkspace,
          );
          updateCache(accessor.store(parsedValue), null);
        } else if (visualId == _userParametersKey) {
          final accessor = const UserParametersAccessor();
          parsedValue = await accessor.interpret(content, this);
          updateCache(accessor.store(parsedValue), null);
        } else if (visualId == _authenticationResponseKey) {
          parsedValue = content.asAuthenticationResponse();
          updateCache([parsedValue], null);
        } else if (visualId == _challengeKey) {
          parsedValue = content.asChallenge();
          updateCache([parsedValue], null);
        } else {
          throw UnimplementedError(
            'Unknown serializable entry name ${cacheType.name}:$visualId.',
          );
        }

        cache[cacheType]![visualId] = parsedValue;
      }
    }
  }

  SerializedSession serialize() {
    return SerializedSession(
      stack: stack.serialize(),
      cache: serializableCache.entries.map(
        (e) => CacheSection(type: e.key, values: e.value.entries),
      ),
    );
  }

  Map<String, dynamic> exportJson() => serialize().writeToJsonMap();

  String exportString() => serialize().writeToJson();

  Uint8List exportBinary() => serialize().writeToBuffer();

  Future<void> ensurePage(int page) async {
    final oldPage = stack.clientSignature?.tab;

    if (oldPage == page) {
      return;
    }

    stack.changeTab(page);

    if (options.saveNavigationRequests) {
      return;
    }

    final result = await access(
      NavigationAccessor(previousTabId: oldPage ?? 7, currentTabId: page),
    );

    return result;
  }

  Future<T> access<T>(
    StatefulAccessor<T, dynamic> accessor, {
    Completer<void>? cancellationSignal,
  }) async {
    return await accessor.fetch(this, cancellationSignal);
  }

  T expectAccessorNamed<T>(String key) =>
      cache[CacheType.UNIQUE]![key.visualIdData().visualId];

  bool hasAccessorNamed(String key) =>
      cache[CacheType.UNIQUE]!.containsKey(key.visualIdData().visualId);

  T getCachedValue<T>(CacheType type, String visualId) =>
      cache[type]!.get(visualId);

  SpecificInstanceParameters get instance =>
      expectAccessorNamed<SpecificInstanceParameters>("InstanceParameters");

  BroadInstanceParameters get broadInstance =>
      expectAccessorNamed<BroadInstanceParameters>("InstanceParameters");

  InstanceParameters get anyInstance =>
      expectAccessorNamed<InstanceParameters>("InstanceParameters");

  UserParameters get user =>
      expectAccessorNamed<UserParameters>("UserParameters");

  AuthenticationResponse get auth =>
      expectAccessorNamed<AuthenticationResponse>("AuthenticationResponse");

  int _currentUserResourceId = 0;

  int get currentUserResourceId => _currentUserResourceId;

  set currentUserResourceId(int value) {
    _currentUserResourceId = value;

    if (user.resources.length > 1) {
      stack.changeUserResource(userResource);
    }
  }

  UserResource get userResource => user.resources[currentUserResourceId];

  static final _startMatch = RegExp(r'Start\(');
  static final _endMatch = RegExp(r'\);?}catch');
  static const casBypassParameters = {'login': 'true'};
  static const redirectBypassParameters = {'fd': '1'};
  static const delegationBypassParameters = {
    'bydlg': 'A6ABB224-12DD-4E31-AD3E-8A39A1C2C335',
  };
  static const baseParameters = {
    ...casBypassParameters,
    ...redirectBypassParameters,
  };

  static Future<RemoteSession> init(
    Uri baseUri, {
    Map<String, String> parameters = baseParameters,
    List<Cookie>? cookies,
    Workspace workspace = Workspace.commonMobile,
    bool keepBaseUrl = false,
    bool followRedirects = false,
    SessionOptions? options,
  }) async {
    if (keepBaseUrl && parameters != baseParameters) {
      baseUri = baseUri.replace(
        queryParameters: {...parameters, ...baseUri.queryParameters},
      );
    }

    final client = HttpClient();
    final seedRequest = await client.getUrl(
      keepBaseUrl
          ? baseUri
          : workspace
                .toSpecificAccountKind(baseUri)
                .replace(
                  queryParameters: parameters.isEmpty ? null : parameters,
                ),
    );

    if (keepBaseUrl) {
      baseUri = baseUri.replace(
        pathSegments: [
          ...baseUri.pathSegments.takeWhile((value) => value != 'pronote'),
          'pronote',
        ],
        queryParameters: {},
      );

      final rawBaseUri = baseUri.toString();
      if (rawBaseUri.endsWith('?')) {
        baseUri = Uri.parse(rawBaseUri.substring(0, rawBaseUri.length - 1));
      }
    }

    seedRequest.followRedirects = followRedirects;

    libLog.info(
      'Fetching  ${seedRequest.uri.pathSegments.last} at ${seedRequest.uri}',
    );

    if (cookies?.isNotEmpty ?? false) {
      seedRequest.cookies.addAll(cookies!);
    }

    final seedPageResponse = await seedRequest.close();

    // We got redirected to a CAS
    if (seedPageResponse.statusCode == 302) {
      throw UnexpectedCASRedirect(
        'Got redirected to a CAS',
        Uri.parse(seedPageResponse.headers.value(HttpHeaders.locationHeader)!),
      );
    }

    if (seedPageResponse.statusCode != 200) {
      throw HttpException('Remote page not available.');
    }

    Version? remoteVersion;
    final splitServerHeader = seedPageResponse.headers
        .value('server')
        ?.split(' ');
    if (splitServerHeader != null && splitServerHeader[0] == 'PRONOTE') {
      remoteVersion = Version.parse(splitServerHeader[1]);
    } else {
      // TODO: Add scraping for this.
      remoteVersion = Version(0, 0, 0);
    }

    final body = await seedPageResponse
        .transform(utf8.decoder)
        .map((event) => event.replaceAll(RegExp(r'\s'), ''))
        .join();

    final seedStart = _startMatch.allMatches(body).firstOrNull?.end;
    final seedEnd = _endMatch.allMatches(body).firstOrNull?.start;

    if (seedStart == null || seedEnd == null) {
      throw InvalidInstanceException();
    }

    // Thank you Mikkel ALMONTE-RINGAUD from the Pawnote.js project for the RegEx.
    // Licensing information (GPL-3.0) available in the app. TODO: Credit properly
    final seed = jsonDecode(
      body
          .substring(seedStart, seedEnd)
          .replaceAllMapped(
            RegExp(r'''(['"])?([a-z0-9A-Z_]+)(['"])?:''', unicode: true),
            (match) => '"${match.group(2)}": ',
          )
          .replaceAll("'", '"'),
    ) as Map<String, dynamic>;

    final rsaFromConstants =
        (!seed.containsKey('MR')) && (!seed.containsKey('ER'));

    bool skipEncryption;
    bool skipCompression;

    if (remoteVersion >= Version(2025, 1, 3)) {
      skipEncryption = !(seed.containsKey('CrA') && seed['CrA']);
      skipCompression = !(seed.containsKey('CoA') && seed['CoA']);
    } else {
      skipEncryption = seed['sCrA'] ?? false;
      skipCompression = seed['sCoA'] ?? false;
    }

    assert(skipEncryption && skipCompression);

    final WorkspaceType? workspaceId = seed.containsKey('a')
        ? WorkspaceType.values.byId(seed['a'])
        : null;

    final ivRandom = Random.secure();
    final crypto = Crypto(
      aesIv: Uint8List.fromList(
        List.generate(16, (index) => ivRandom.nextInt(255)),
      ),
      rsaModulus: rsaFromConstants
          ? rsaModulo1024
          : BigInt.parse(seed['MR'], radix: 16),
      rsaExponent: rsaFromConstants
          ? rsaExponent1024
          : BigInt.parse(seed['ER'], radix: 16),
    );
    await crypto.setAesKey(crypto.aesKey);

    options ??= SessionOptions.getDefault();

    return RemoteSession(
      stack: NetworkStack(
        cookies: cookies ?? [],
        vocab: ApiVocabulary.forVersion(remoteVersion),
        crypto: crypto,
        baseUrl: baseUri,
        remoteVersion: remoteVersion,
        demo: seed['d'] ?? false,
        http: (seed.containsKey('http') && seed['http']),
        poll:
            (seed.containsKey('poll') && seed['poll']) ||
            remoteVersion >= Version(2025, 1, 3),
        rsaFromConstants: rsaFromConstants,
        skipCompression: skipCompression,
        skipEncryption: skipEncryption,
        sessionId: int.parse(seed['h'].toString()),
        temporaryWorkspace: Workspace(
          type: workspaceId ?? workspace.type,
          label: workspace.label,
          pathSegment: workspace.pathSegment,
        ),
        tokenId: seed['e'],
        tokenKey: seed['f'],
        debugMode: options.debugMode,
      ),
      options: options,
    );
  }

  RemoteSession({
    required this.stack,
    SerializableCacheStore? serializableCache,
    required this.options,
  }) {
    if (serializableCache == null) {
      this.serializableCache = {};
    } else {
      this.serializableCache = serializableCache;
    }
  }
}
