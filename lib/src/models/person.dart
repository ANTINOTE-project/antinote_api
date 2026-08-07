import 'dart:typed_data';

import 'package:antinote_api/antinote_api.dart';

final class const Person({
  required final String name,
  required final String? id,
  required final int? type,
  required final int? place,
  required final bool withDiscussion,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    name: nav.get('L'),
    id: nav.get('N'),
    type: nav.get('G'),
    place: nav.get('P'),
    withDiscussion: nav.get('avecDiscussion') ?? false,
  );

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
