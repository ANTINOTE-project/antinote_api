import 'dart:typed_data';

import 'package:antinote/src/helpers/datetime.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

final class Holiday with VisualIdMixin {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  const Holiday({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  bool contains(DateTime day) {
    final actualDay = day.toDay();
    return !startDate.isAfter(actualDay) && !endDate.isBefore(actualDay);
  }

  @override
  CacheType? get cacheType => CacheType.HOLIDAY;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name.visualIdData();
    yield startDate.millisecondsSinceEpoch.bytesVisualIdData();
    yield endDate.millisecondsSinceEpoch.bytesVisualIdData();
  }
}

extension ToHoliday on MapJsonNavigator {
  Holiday asHoliday() => Holiday(
    id: get('N'),
    name: get('L'),
    startDate: get('dateDebut'),
    endDate: get('dateFin'),
  );
}
