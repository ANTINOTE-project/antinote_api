import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/datetime.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';

final class const Holiday({
  required final String id,
  required final String name,
  required final DateTime startDate,
  required final DateTime endDate,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    name: nav.get('L'),
    startDate: nav.get('dateDebut'),
    endDate: nav.get('dateFin'),
  );

  bool contains(DateTime day) {
    final actualDay = day.toDay();
    return !startDate.isAfter(actualDay) && !endDate.isBefore(actualDay);
  }

  @override
  CacheType? get cacheType => .HOLIDAY;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name.visualIdData();
    yield startDate.millisecondsSinceEpoch.bytesVisualIdData();
    yield endDate.millisecondsSinceEpoch.bytesVisualIdData();
  }
}
