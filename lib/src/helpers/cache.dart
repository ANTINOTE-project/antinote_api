import 'dart:collection';

import 'package:antinote/src/helpers/json_codec.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/protos/antinote/session.pbenum.dart';

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
    List<VisualIdMixin> objects,
    Map<String, dynamic>? rawRequest,
  ) {
    final totalToStore = Queue<VisualIdMixin>.from(objects);
    while (totalToStore.isNotEmpty) {
      final toStore = totalToStore.removeFirst();
      totalToStore.addAll(toStore.toStore);
      if (toStore.cacheType == null) continue;

      if (rawRequest != null &&
          cacheTypesToSerialize.contains(toStore.cacheType!)) {
        serializableCache.putIfAbsent(
          toStore.cacheType!,
          () => {},
        )[toStore.visualId] = RemoteJsonEncoder(
          data: rawRequest,
        ).encode();
      }

      cache[toStore.cacheType!]![toStore.visualId] = toStore;
    }
  }
}
