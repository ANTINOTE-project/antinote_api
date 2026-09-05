import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:antinote_api/antinote_api.dart';
import 'package:antinote_api/src/helpers/api_properties.dart';
import 'package:antinote_api/src/helpers/localization.dart';
import 'package:antinote_api/src/helpers/serial.dart';
import 'package:antinote_api/src/models/authentication_response.dart';
import 'package:version/version.dart';

class RemoteSession with SerializableObject<SerializedSession> {
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

    session.stack.locale = options?.hasLocale() ?? false
        ? options!.locale
        : null;

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

  Future<void> _reconstructCache() async {
    for (final MapEntry(key: cacheType, value: cached)
        in serializableCache.entries) {
      for (final MapEntry(key: visualId, value: rawContent) in cached.entries) {
        final content = RemoteJsonDecoder(data: rawContent).decode();

        final parsedValue = switch (SerialObjectId.values
            .where((element) => element.writtenId == visualId)
            .singleOrNull) {
          .instanceParameters => InstanceParameters.decode(
            content,
            stack.temporaryWorkspace,
          ),
          .userParameters => UserParameters.decode(this, content),
          .authenticationData => AuthenticationResponse.decode(content),
          .challenge => Challenge.decode(content),
          .offPeriod => OffTimeParameters.decode(this, content),
          null => throw UnimplementedError(
            'Unknown serializable entry name ${cacheType.name}:$visualId.',
          ),
        };

        updateCache([.stay(parsedValue)], content);
        cache[cacheType]![visualId] = parsedValue;
      }
    }
  }

  @override
  SerializedSession serialize() {
    return SerializedSession(
      stack: stack.serialize(),
      cache: serializableCache.entries.map(
        (e) => CacheSection(type: e.key, values: e.value.entries),
      ),
    );
  }

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
    Accessor<T> accessor, {
    Completer<void>? cancellationSignal,
  }) async {
    return await accessor.fetch(this, cancellationSignal);
  }

  T expectAccessorNamed<T>(SerialObjectId key) =>
      cache[CacheType.UNIQUE]![key.writtenId];

  bool hasAccessorNamed(SerialObjectId key) =>
      cache[CacheType.UNIQUE]!.containsKey(key.writtenId);

  T getCachedValue<T>(CacheType type, String visualId) =>
      cache[type]!.get(visualId);

  SpecificInstanceParameters get instance =>
      expectAccessorNamed<SpecificInstanceParameters>(.instanceParameters);

  BroadInstanceParameters get broadInstance =>
      expectAccessorNamed<BroadInstanceParameters>(.instanceParameters);

  InstanceParameters get anyInstance => expectAccessorNamed<InstanceParameters>(
    SerialObjectId.instanceParameters,
  );

  UserParameters get user =>
      expectAccessorNamed<UserParameters>(.userParameters);

  AuthenticationResponse get auth =>
      expectAccessorNamed<AuthenticationResponse>(.authenticationData);

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

  static Uri _removeQuery(Uri uri) {
    if (!uri.hasQuery) return uri;
    return Uri(
      scheme: uri.hasScheme ? uri.scheme : null,
      host: uri.hasAuthority ? uri.host : null,
      port: uri.hasPort ? uri.port : null,
      path: uri.path,
      fragment: uri.hasFragment ? uri.fragment : null,
    );
  }

  static Future<RemoteSession> init(
    Uri uri, {
    Map<String, String>? parameters,
    List<Cookie>? cookies,
    Workspace workspace = .commonMobile,
    bool isCustomUrl = false,
    bool followRedirects = false,
    SessionOptions? options,
  }) async {
    Uri baseUri;

    if (isCustomUrl) {
      uri = uri.replace(
        queryParameters: {...?parameters, ...uri.queryParameters},
      );
      baseUri = uri.replace(
        pathSegments: uri.pathSegments
            .takeWhile(
              (value) =>
                  value != workspace.pathSegment &&
                  value != uri.pathSegments.last,
            )
            .toList(growable: false),
        queryParameters: {},
      );
    } else {
      baseUri = uri.replace(queryParameters: {});
      uri = workspace
          .toSpecificAccountKind(uri)
          .replace(queryParameters: {...?parameters, ...uri.queryParameters});
    }

    if (uri.queryParameters.isEmpty) {
      uri = _removeQuery(uri);
      assert(!uri.hasQuery);
    }

    final client = HttpClient();
    var seedRequest = await client.getUrl(uri);

    seedRequest.followRedirects = false;

    logger.info(
      'Fetching  ${seedRequest.uri.pathSegments.last} at ${seedRequest.uri}',
    );

    seedRequest.cookies.add(
      localeCookie(options?.hasLocale() ?? false ? options!.locale : null),
    );
    if (cookies?.isNotEmpty ?? false) {
      seedRequest.cookies.addAll(cookies!);
    }

    var seedPageResponse = await seedRequest.close();

    // We got redirected to a CAS
    if (seedPageResponse.statusCode == 302 ||
        seedPageResponse.headers.value(HttpHeaders.locationHeader) != null) {
      uri = uri.resolve(
        seedPageResponse.headers.value(HttpHeaders.locationHeader)!,
      );

      if (!followRedirects) {
        throw UnexpectedCASRedirect('Got redirected to a CAS', uri);
      }

      while (seedPageResponse.statusCode == 302 ||
          seedPageResponse.headers.value(HttpHeaders.locationHeader) != null) {
        seedRequest = await client.getUrl(
          uri.replace(
            queryParameters: {...?parameters, ...uri.queryParameters},
          ),
        );
        seedRequest.followRedirects = false;
        seedRequest.cookies.add(
          localeCookie(options?.hasLocale() ?? false ? options!.locale : null),
        );
        if (cookies?.isNotEmpty ?? false) {
          seedRequest.cookies.addAll(cookies!);
        }

        seedPageResponse = await seedRequest.close();
      }
    }

    if (seedPageResponse.statusCode != 200) {
      throw const HttpException('Remote page not available.');
    }

    Version? remoteVersion;
    final splitServerHeader = seedPageResponse.headers
        .value('server')
        ?.split(' ');
    if (splitServerHeader != null && splitServerHeader[0] == 'PRONOTE') {
      final versionNumbers = splitServerHeader[1]
          .split('.')
          .mapL((e) => int.parse(e));
      remoteVersion = Version(
        versionNumbers[0],
        versionNumbers[1],
        versionNumbers[2],
        build: versionNumbers.skip(3).join('.'),
      );
    } else {
      // We assume this is a change that could happen in a future version, we
      // put it to "the future" (next year version from latest supported).
      remoteVersion = Version(2027, 0, 0);
    }

    final body = await seedPageResponse
        .transform(utf8.decoder)
        .map((event) => event.replaceAll(RegExp(r'\s'), ''))
        .join();

    final seedStart = _startMatch.allMatches(body).firstOrNull?.end;
    final seedEnd = _endMatch.allMatches(body).firstOrNull?.start;

    if (seedStart == null || seedEnd == null) {
      throw const InvalidInstanceException();
    }

    final seed = jsonDecode(
      remoteVersion.major >= 2026
          ? body.substring(seedStart, seedEnd)
          : body
                .substring(seedStart, seedEnd)
                .replaceAllMapped(
                  RegExp(r'([{,])(\w+):', unicode: true),
                  (match) => '${match.group(1)}"${match.group(2)}":',
                )
                .replaceAll("'", '"'),
    ) as Map<String, dynamic>;

    final rsaFromConstants = (!seed.has('MR')) && (!seed.has('ER'));

    bool skipEncryption;
    bool skipCompression;

    if (remoteVersion >= Version(2025, 1, 3)) {
      skipEncryption = !seed.getB('CrA');
      skipCompression = !seed.getB('CoA');
    } else {
      skipEncryption = seed.getB('sCrA');
      skipCompression = seed.getB('sCoA');
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
          : BigInt.parse(seed.get<String>('MR'), radix: 16),
      rsaExponent: rsaFromConstants
          ? rsaExponent1024
          : BigInt.parse(seed.get<String>('ER'), radix: 16),
    );
    await crypto.setAesKey(crypto.aesKey);

    options ??= SessionOptions.getDefault();

    baseUri = _removeQuery(baseUri);
    assert(!baseUri.hasQuery);

    return RemoteSession(
      stack: NetworkStack(
        cookies: cookies ?? [],
        locale: options.hasLocale() ? options.locale : null,
        vocab: ApiVocabulary.forVersion(remoteVersion),
        crypto: crypto,
        baseUrl: baseUri,
        remoteVersion: remoteVersion,
        demo: seed.getB('d'),
        http: seed.getB('http'),
        poll: seed.getB('poll') || remoteVersion >= Version(2025, 1, 3),
        rsaFromConstants: rsaFromConstants,
        skipCompression: skipCompression,
        skipEncryption: skipEncryption,
        sessionId: int.parse(seed.get('h').toString()),
        temporaryWorkspace: Workspace(
          type: workspaceId ?? workspace.type,
          label: workspace.label,
          pathSegment: workspace.pathSegment,
        ),
        tokenId: seed.get('e'),
        tokenKey: seed.get('f'),
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
