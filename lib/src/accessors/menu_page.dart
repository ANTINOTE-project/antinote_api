import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/date.dart';
import 'package:antinote/src/models/menu/page.dart';

class MenuPageAccessor extends StatelessAccessor<MenuPage> {
  final DateTime date;

  const MenuPageAccessor({required this.date});

  @override
  bool get exclusiveFriendly => true;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          Call.function(
            name: 'PageMenus',
            dataSec: {
              session.stack.vocab.data: {
                'date': {'_T': 7, 'V': date.asRemoteDate()},
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .resultCompleter
        .future
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<MenuPage> interpretStateless(MapJsonNavigator nav) {
    return nav.asMenuPage();
  }

  @override
  List<VisualIdMixin> store(MenuPage result) => [
    for (final menu in result.menus) ...menu.meals,
  ];
}
