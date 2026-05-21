import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/tab.dart';
import 'package:antinote/src/models/user/authorizations.dart';
import 'package:antinote/src/models/user/resource.dart';

final class UserParameters with VisualIdMixin {
  @override
  CacheType? get cacheType => .UNIQUE;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield "UserParameters".visualIdData();
  }

  final String id;
  final int type;
  final String name;

  final UserAuthorizations authorizations;
  final List<UserResource> resources;

  final List<Tab> tabs;
  final List<int> hiddenTabIds;
  final List<int> notificationTabIds;

  const UserParameters({
    required this.id,
    required this.type,
    required this.name,
    required this.authorizations,
    required this.resources,
    required this.tabs,
    required this.hiddenTabIds,
    required this.notificationTabIds,
  });

  bool hasAccessToTab(int tab) {
    return tabs.any((element) => element.hasTab(tab));
  }
}
