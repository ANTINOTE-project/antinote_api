import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/tab.dart';

import '../../helpers/visual_id.dart';

final class StudentClass with VisualIdMixin {
  final String id;
  final String name;

  const StudentClass({required this.id, required this.name});

  Map<String, dynamic> toRaw() => {'L': name, 'N': id};

  @override
  CacheType? get cacheType => .STUDENT_CLASS;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield name.visualIdData();
  }
}

extension AsStudentClass on MapJsonNavigator {
  StudentClass asStudentClass() {
    return StudentClass(id: get('N'), name: get('L'));
  }
}

final class UserResource with VisualIdMixin {
  final String id;
  final int type;
  final String name;
  final StudentClass? studentClass;
  final String? establishmentName;
  final Uint8List? profilePicture;
  final bool isDirector;
  final bool isDelegate;
  final bool isMemberCa;
  final List<Tab> tabsForPeriods;

  const UserResource({
    required this.id,
    required this.type,
    required this.name,
    required this.studentClass,
    required this.establishmentName,
    required this.profilePicture,
    required this.isDirector,
    required this.isDelegate,
    required this.isMemberCa,
    required this.tabsForPeriods,
  });

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

extension AsUserResource on MapJsonNavigator {
  UserResource asUserResource(ListJsonNavigator<String> files) {
    List<Tab> tabs = [];

    if (has('listeOngletsPourPeriodes')) {
      for (final rawTab in getLM('listeOngletsPourPeriodes')) {
        tabs.add(rawTab.asTab());
      }
    }

    return UserResource(
      id: get('N'),
      type: get('G'),
      name: get('L'),
      studentClass: mGo('classeDEleve')?.asStudentClass(),
      establishmentName: mGo('Etablissement')?.get('L'),
      profilePicture: (get('avecPhoto') ?? false) ? get('photoBase64') : null,
      isDirector: get('estDirecteur') ?? false,
      isDelegate: get('estDelegue') ?? false,
      isMemberCa: get('estMembreCA') ?? false,
      tabsForPeriods: tabs,
    );
  }
}
