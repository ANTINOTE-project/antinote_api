import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/tab.dart';

import '../../helpers/visual_id.dart';

final class const StudentClass({
  required final String id,
  required final String name,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) =>
      .new(id: nav.get('N'), name: nav.get('L'));

  Map<String, dynamic> toRaw() => {'L': name, 'N': id};

  @override
  CacheType? get cacheType => .STUDENT_CLASS;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name.visualIdData();
  }
}

final class const UserResource({
  required final String id,
  required final int type,
  required final String name,
  required final StudentClass? studentClass,
  required final String? establishmentName,
  required final Uint8List? profilePicture,
  required final bool isDirector,
  required final bool isDelegate,
  required final bool isMemberCa,
  required final List<Tab> tabsForPeriods,
}) with VisualIdMixin {
  factory decode(Map<String, dynamic> nav) {
    List<Tab> tabs = [];

    if (nav.has('listeOngletsPourPeriodes')) {
      for (final rawTab in nav.getLM('listeOngletsPourPeriodes')) {
        tabs.add(.decode(rawTab));
      }
    }

    return .new(
      id: nav.get('N'),
      type: nav.get('G'),
      name: nav.get('L'),
      studentClass: nav.mGo('classeDEleve').inn((value) => .decode(value)),
      establishmentName: nav.mGo('Etablissement')?.get('L'),
      profilePicture: (nav.get('avecPhoto') ?? false)
          ? nav.get('photoBase64')
          : null,
      isDirector: nav.get('estDirecteur') ?? false,
      isDelegate: nav.get('estDelegue') ?? false,
      isMemberCa: nav.get('estMembreCA') ?? false,
      tabsForPeriods: tabs,
    );
  }

  Map<String, dynamic> toRaw() => {'G': type, 'L': name, 'N': id};

  @override
  CacheType? get cacheType => .USER_RESOURCE;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield type.byteVisualIdData();
    yield name.visualIdData();
    yield* studentClass?.collectVisualIdData() ?? [];
    yield establishmentName?.visualIdData();
  }
}
