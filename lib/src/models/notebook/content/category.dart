import 'dart:typed_data';

import 'package:antinote/src/helpers/enum_id.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/helpers/cache.dart';

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

final class NotebookContentCategory with VisualIdMixin {
  final String? id;
  final String? label;
  final NotebookContentCategoryType type;
  final String iconLabel;

  const NotebookContentCategory({
    required this.id,
    required this.label,
    required this.type,
    required this.iconLabel,
  });

  @override
  CacheType? get cacheType => .NOTEBOOK_CONTENT_CATEGORY;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield label?.visualIdData();
    yield type.id.byteVisualIdData();
    yield iconLabel.visualIdData();
  }
}

extension AsNotebookContentCategory on MapJsonNavigator {
  NotebookContentCategory? mAsNotebookContentCategory() {
    if (!has('L') || get('N') == '0') return null;

    return NotebookContentCategory(
      id: get('N'),
      label: get('L'),
      type: NotebookContentCategoryType.values.byId(get('G')),
      iconLabel: get('libelleIcone'),
    );
  }
}
