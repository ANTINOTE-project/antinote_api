import 'dart:typed_data';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

final class Period with VisualIdMixin {
  final String? id;
  final String name;
  final int? type;
  final int? notationPeriodType;
  final DateTime? startDate;
  final DateTime? endDate;

  const Period({
    required this.id,
    required this.name,
    required this.type,
    required this.notationPeriodType,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> asRaw() => {'G': type, 'L': name, 'N': id ?? 0};

  @override
  CacheType? get cacheType => .PERIOD;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name.visualIdData();
    yield type?.byteVisualIdData();
    yield notationPeriodType?.byteVisualIdData();
    yield startDate?.millisecondsSinceEpoch.bytesVisualIdData();
    yield endDate?.millisecondsSinceEpoch.bytesVisualIdData();
  }
}

extension AsPeriod on MapJsonNavigator {
  Period asPeriod() => Period(
    id: get('N'),
    name: get('L'),
    type: get('G'),
    notationPeriodType: get('periodeNotation'),
    startDate: get('dateDebut'),
    endDate: get('dateFin'),
  );
}
