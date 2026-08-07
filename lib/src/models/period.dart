import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';

final class const Period({
  required final String? id,
  required final String name,
  required final int? type,
  required final int? notationPeriodType,
  required final DateTime? startDate,
  required final DateTime? endDate,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) => .new(
    id: nav.get('N'),
    name: nav.get('L'),
    type: nav.get('G'),
    notationPeriodType: nav.get('periodeNotation'),
    startDate: nav.get('dateDebut'),
    endDate: nav.get('dateFin'),
  );

  Map<String, dynamic> asJson() => {'G': type, 'L': name, 'N': id ?? 0};

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
