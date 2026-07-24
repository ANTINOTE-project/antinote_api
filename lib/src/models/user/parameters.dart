import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/tab.dart';
import 'package:antinote/src/models/user/authorizations.dart';
import 'package:antinote/src/models/user/resource.dart';

final class const UserParameters({
  required final String id,
  required final int type,
  required final String name,

  required final UserAuthorizations authorizations,
  required final List<UserResource> resources,

  required final List<Tab> tabs,
  required final List<int> hiddenTabIds,
  required final List<int> notificationTabIds,
}) with VisualIdMixin {
  @override
  CacheType? get cacheType => .UNIQUE;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield "UserParameters".visualIdData();
  }

  bool hasAccessToTab(int tab) {
    return tabs.any((element) => element.hasTab(tab));
  }
}
