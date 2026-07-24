typedef MapJsonNavigator<E> = Map<String, E>;

extension MapJsonNavigatorExt<E> on Map<String, E> {
  T get<T extends E>(String key) {
    final value = this[key];

    if (value is JsonReference) {
      assert(value.value is T);
      return value.value;
    }

    return value as T;
  }

  bool getB(String key) {
    return switch (this[key]) {
      false => false,
      0 => false,
      0.0 => false,
      "" => false,
      num(isNaN: final isNaN) => isNaN,
      _ => true,
    };
  }

  MapJsonNavigator goIterable(List<String> keys) {
    if (keys.isEmpty) return this;

    return getM(keys.first).goIterable(keys.sublist(1));
  }

  // Yes, it looks really bad. But Dart does it too so I am doing it too.
  // dart format off
  MapJsonNavigator go(String key1,
      [String? key2, String? key3, String? key4, String? key5,
        String? key6, String? key7, String? key8, String? key9, String? key10,
        String? key11, String? key12, String? key13, String? key14, String? key15,
        String? key16, String? key17, String? key18, String? key19, String? key20,
      ]) =>
      goIterable([
        key1, ?key2, ?key3, ?key4, ?key5, ?key6, ?key7, ?key8, ?key9, ?key10,
        ?key11, ?key12, ?key13, ?key14, ?key15, ?key16, ?key17, ?key18, ?key19,
        ?key20,
      ]);

  // dart format on

  MapJsonNavigator? mGoIterable(List<String> keys) {
    if (keys.isEmpty) return this;

    if (!has(keys.first)) return null;

    return getM(keys.first).mGoIterable(keys.sublist(1));
  }

  // dart format off
  MapJsonNavigator? mGo(String key1,
      [String? key2, String? key3, String? key4, String? key5,
        String? key6, String? key7, String? key8, String? key9, String? key10,
        String? key11, String? key12, String? key13, String? key14, String? key15,
        String? key16, String? key17, String? key18, String? key19, String? key20,
      ]) =>
      mGoIterable([
        key1, ?key2, ?key3, ?key4, ?key5, ?key6, ?key7, ?key8, ?key9, ?key10,
        ?key11, ?key12, ?key13, ?key14, ?key15, ?key16, ?key17, ?key18, ?key19,
        ?key20,
      ]);

  // dart format on

  MapJsonNavigator? eGoIterable(List<List<String>> keys) {
    if (keys.isEmpty) return this;

    final foundKey = keys.first.cast<String?>().firstWhere(
      (key) => has(key!),
      orElse: () => null,
    );
    if (foundKey == null) return null;

    return getM(foundKey).eGoIterable(keys.sublist(1));
  }

  // dart format off
  MapJsonNavigator? eGo(List<String> key1,
      [List<String>? key2, List<String>? key3, List<String>? key4,
        List<String>? key5, List<String>? key6, List<String>? key7,
        List<String>? key8, List<String>? key9, List<String>? key10,
        List<String>? key11, List<String>? key12, List<String>? key13,
        List<String>? key14, List<String>? key15, List<String>? key16,
        List<String>? key17, List<String>? key18, List<String>? key19,
        List<String>? key20,
      ]) =>
      eGoIterable([
        key1, ?key2, ?key3, ?key4, ?key5, ?key6, ?key7, ?key8, ?key9, ?key10,
        ?key11, ?key12, ?key13, ?key14, ?key15, ?key16, ?key17, ?key18, ?key19,
        ?key20,
      ]);

  // dart format on

  bool has(String key) => containsKey(key);

  bool hasAny(List<String> keys) => keys.any((key) => containsKey(key));

  ListJsonNavigator<T> getL<T>(String key) =>
      (get(key) as ListJsonNavigator).cast<T>();

  ListJsonNavigator<T>? mGetL<T>(String key) =>
      has(key) ? (get(key) as ListJsonNavigator).cast<T>() : null;

  ListJsonNavigator<MapJsonNavigator> getLM(String key) =>
      (get(key) as ListJsonNavigator).cast<MapJsonNavigator>().toList();

  ListJsonNavigator<MapJsonNavigator>? mGetLM(String key) => has(key)
      ? (get(key) as ListJsonNavigator).cast<MapJsonNavigator>().toList()
      : null;

  MapJsonNavigator<T> getM<T>(String key) =>
      (get(key) as MapJsonNavigator).cast<String, T>();

  MapJsonNavigator<T>? mGetM<T>(String key) =>
      has(key) ? (get(key) as Map<String, dynamic>).cast<String, T>() : null;

  String? _getCorrectKey(Iterable<String> keys) {
    for (final key in keys) {
      if (has(key)) return key;
    }

    return null;
  }

  ListJsonNavigator<T>? eGetL<T>(Iterable<String> keys) {
    final correctKey = _getCorrectKey(keys);
    if (correctKey == null) return null;

    return (get(correctKey) as ListJsonNavigator).cast<T>();
  }

  ListJsonNavigator<MapJsonNavigator>? eGetLM(Iterable<String> keys) {
    final correctKey = _getCorrectKey(keys);
    if (correctKey == null) return null;

    return (get(correctKey) as ListJsonNavigator)
        .cast<MapJsonNavigator>()
        .toList();
  }

  MapJsonNavigator<T>? eGetM<T extends E>(Iterable<String> keys) {
    final correctKey = _getCorrectKey(keys);
    if (correctKey == null) return null;

    return (get(correctKey) as MapJsonNavigator).cast<String, T>();
  }

  T? eGet<T extends E>(Iterable<String> keys) {
    final correctKey = _getCorrectKey(keys);
    if (correctKey == null) return null;

    return get(correctKey) as T;
  }

  bool empty() => isEmpty;

  bool notEmpty() => isNotEmpty;

  Iterator<MapEntry<String, E>> get iterator => entries.iterator;

  // TODO: Add a system that ensures all fields of a map are read or else it gives out warnings.
}

typedef ListJsonNavigator<E> = List<E>;

extension ListJsonNavigatorExt<E> on ListJsonNavigator<E> {
  T get<T extends E>(int index) {
    final value = this[index];

    if (value is JsonReference) {
      assert(value.value is T);
      return value.value;
    }

    return value as T;
  }

  ListJsonNavigator<T> mapL<T>(
    T Function(E e) toElement, [
    bool growable = false,
  ]) => map(toElement).toList(growable: growable);

  ListJsonNavigator<T> getL<T extends E>(int index) =>
      (get(index) as ListJsonNavigator).cast<T>();

  ListJsonNavigator<MapJsonNavigator> getLM(int index) =>
      (get(index) as ListJsonNavigator).cast<MapJsonNavigator>();

  MapJsonNavigator<T> getM<T extends E>(int index) =>
      (get(index) as MapJsonNavigator).cast<String, T>();

  bool get empty => isEmpty;

  bool get notEmpty => isNotEmpty;
}

class JsonReference<T> {
  final dynamic rawReference;
  final T Function(MapJsonNavigator nav) _resolver;
  final dynamic Function(T resolved) _serializer;

  bool _loaded = false;
  T? value;

  JsonReference({
    required this.rawReference,
    required this._resolver,
    required this._serializer,
  });

  void resolve(MapJsonNavigator nav) {
    value = _resolver(nav);
    _loaded = true;
  }

  dynamic serialize() {
    if (!_loaded) {
      throw StateError("Tried to serialize reference that wasn't resolved");
    }

    return _serializer(value!);
  }
}

/// [map1] has priority over [map2].
Map<String, dynamic> deepMergeMaps(
  Map<String, dynamic> map1,
  Map<String, dynamic> map2, {
  bool mergeInnerMaps = true,
}) {
  final result = <String, dynamic>{};

  for (final mapEntry in [...map1.entries, ...map2.entries]) {
    if (!result.containsKey(mapEntry.key)) {
      result[mapEntry.key] = mapEntry.value;
      continue;
    }

    if (result[mapEntry.key] is Map) {
      if (mapEntry.value is! Map) {
        throw Exception(
          'Tried to merge ${result[mapEntry.key].runtimeType} and ${mapEntry.value.runtimeType}',
        );
      }

      if (mergeInnerMaps) {
        result[mapEntry.key] = deepMergeMaps(
          result[mapEntry.key],
          mapEntry.value,
        );
      } else {
        result[mapEntry.key] = mapEntry.value;
      }
    }
  }

  return result;
}

extension IfNotNull<T> on T? {
  O? inn<O>(O Function(T value) run) {
    if (this == null) return null;
    return run(this as T);
  }
}
