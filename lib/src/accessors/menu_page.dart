import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/date.dart';
import 'package:antinote/src/models/menu/page.dart';

class MenuPageAccessor extends StatelessAccessor<MenuPage> {
  final DateTime date;

  const MenuPageAccessor({required this.date});

  @override
  FutureOr<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) {
    return stack
        .post(
          Call.function(
            name: 'PageMenus',
            dataSec: {
              stack.vocab.data: {
                'date': {'_T': 7, 'V': date.asPronoteDate()},
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .resultCompleter
        .future
        .thenField(stack.vocab.data);
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
