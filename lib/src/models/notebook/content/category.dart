import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/enum_id.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';

enum NotebookContentCategoryType implements EnumId {
  user(0),
  preLesson(1),
  preCorrection(2),
  preDevoir(3),
  preInterrogation(4),
  preTD(5),
  preTP(6),
  preEvaluation(7),
  preEPI(8),
  preAP(9),
  preModPedaOral(10),
  preModPedaEcrit(11),
  preLienVisio(12),
  preCCF(13),
  preEC(14);

  @override
  final int id;

  const NotebookContentCategoryType(this.id);
}

final class const NotebookContentCategory({
  required final String? id,
  required final String? label,
  required final NotebookContentCategoryType type,
  required final String iconLabel,
}) with VisualIdMixin {
  static bool canDecode(Map<String, dynamic> nav) =>
      nav.has('L') && nav.get('N') != '0';

  static NotebookContentCategory? tryDecode(Map<String, dynamic> nav) =>
      !canDecode(nav) ? null : .decode(nav);

  factory decode(Map<String, dynamic> nav) {
    return .new(
      id: nav.get('N'),
      label: nav.get('L'),
      type: NotebookContentCategoryType.values.byId(nav.get('G')),
      iconLabel: nav.get('libelleIcone'),
    );
  }

  @override
  CacheType? get cacheType => .NOTEBOOK_CONTENT_CATEGORY;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label?.visualIdData();
    yield type.id.byteVisualIdData();
    yield iconLabel.visualIdData();
  }
}
