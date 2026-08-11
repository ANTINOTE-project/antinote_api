import 'dart:async';

import 'package:antinote_api/src/accessors/accessors.dart';
import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/network_stack.dart';
import 'package:antinote_api/src/helpers/session.dart';
import 'package:antinote_api/src/models/menu/page.dart';

final class const MenuPageAccessor({required final DateTime date})
    extends Accessor<MenuPage> {
  @override
  bool get exclusiveFriendly => true;

  static const int pageId = 10;

  @override
  int? get page => MenuPageAccessor.pageId;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
            name: 'PageMenus',
            dataSec: {
              session.stack.vocab.data: {'date': date},
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<MenuPage> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) => .decode(nav);

  @override
  List<VisualNavigator> store(MenuPage result) => [.stay(result)];
}
