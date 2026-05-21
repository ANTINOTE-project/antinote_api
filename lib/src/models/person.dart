import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

final class Person with VisualIdMixin {
  final String name;
  final String? id;
  final int? type;
  final int? place;
  final bool withDiscussion;

  const Person({
    required this.name,
    required this.id,
    required this.type,
    required this.place,
    required this.withDiscussion,
  });

  Map<String, dynamic> toJson() {
    return {
      'L': name,
      'N': id,
      'G': type,
      if (place != null) 'P': place,
      if (withDiscussion) 'avecDiscussion': true,
    };
  }

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name.visualIdData();
    yield type?.byteVisualIdData();
    yield withDiscussion.visualIdData();
  }

  @override
  CacheType? get cacheType => .PERSON;
}

extension AsPerson on MapJsonNavigator {
  Person asPerson() {
    return Person(
      name: get('L'),
      id: get('N'),
      type: get('G'),
      place: get('P'),
      withDiscussion: get('avecDiscussion') ?? false,
    );
  }
}
