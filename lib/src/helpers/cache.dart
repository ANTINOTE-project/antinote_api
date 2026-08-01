import 'package:antinote/antinote.dart';
import 'package:antinote/src/helpers/serial.dart';

export 'package:antinote/src/protos/antinote/session.pbenum.dart'
    show CacheType;

typedef _BaseCacheStore<T> = Map<CacheType, Map<VisualId, T>>;
typedef CacheStore = _BaseCacheStore<dynamic>;
typedef SerializableCacheStore = _BaseCacheStore<String>;

const cacheTypesToSerialize = <CacheType>[.UNIQUE];

final class VisualReference<T> {
  final CacheType type;
  final VisualId cachedVisualReference;

  const VisualReference(this.type, this.cachedVisualReference);

  T resolve(RemoteSession session) =>
      session.cache[type]![cachedVisualReference]!;
}

extension CacheExtension on RemoteSession {
  void updateCache(
    List<VisualNavigator> objects,
    Map<String, dynamic>? rawContent,
  ) {
    for (final object in objects) {
      final curNav = rawContent == null
          ? null
          : Map<String, dynamic>.fromEntries(
              object.exchanger(rawContent).entries,
            );

      if (curNav != null &&
          cacheTypesToSerialize.contains(object.value.cacheType) &&
          !object.value.sensitive) {
        serializableCache.putIfAbsent(
          object.value.cacheType!,
          () => {},
        )[object.value.overrideSerialId?.writtenId ??
            object.value.visualId] = RemoteJsonEncoder(data: curNav)
            .encode();
      }

      if (!object.value.sensitive && object.value.cacheType != null) {
        cache[object.value.cacheType!]![object.value.visualId] = object.value;
      }

      updateCache(object.value.toStore, curNav);
    }
  }
}

typedef VisualNavigatorCallback = Map<String, dynamic> Function(
  Map<String, dynamic> nav,
);

final class const VisualNavigator({
  required final VisualNavigatorCallback exchanger,
  required final VisualIdMixin value,
}) {
  new stay(VisualIdMixin value) : this(exchanger: (nav) => nav, value: value);

  new go(VisualIdMixin value, {required String field})
    : this(exchanger: (nav) => nav.getM(field), value: value);

  new eGo(VisualIdMixin value, {required List<String> fields})
    : this(exchanger: (nav) => nav.eGo(fields)!, value: value);

  new indexed(VisualIdMixin value, {required String field, required int index})
    : this(exchanger: (nav) => nav.getLM(field).getM(index), value: value);

  new eIndexed(
    VisualIdMixin value, {
    required List<String> possibleFields,
    required int index,
  }) : this(
         exchanger: (nav) => nav.eGetLM(possibleFields)!.getM(index),
         value: value,
       );
}

enum SerialObjectId(final String writtenId) {
  instanceParameters('instance'),
  userParameters('user'),
  authenticationData('auth'),
  challenge('challenge'),
  offPeriod('off_period')
}
