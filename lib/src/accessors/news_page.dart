import 'dart:async';

import 'package:antinote_api/src/accessors/accessors.dart';
import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/network_stack.dart';
import 'package:antinote_api/src/helpers/session.dart';
import 'package:antinote_api/src/models/domain.dart';
import 'package:antinote_api/src/models/news/display_mode.dart';
import 'package:antinote_api/src/models/news/page.dart';

final class const NewsPageAccessor({required final List<NewsDisplayMode> modes})
    extends Accessor<NewsPage> {
  const NewsPageAccessor.defaultMode() : this(modes: const [.reception]);

  @override
  bool get exclusiveFriendly => true;

  @override
  int? get page => 8;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
            name: 'PageActualites',
            dataSec: {
              session.stack.vocab.data: {
                'genreRequeteActualite': NewsPageRequestType.display.id,
                'modesAffActus': {
                  '_T': 26,
                  'V': modes.map((e) => e.id).asDomain(),
                },
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<NewsPage> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) => .decode(nav);

  @override
  List<VisualNavigator> store(NewsPage result) => [.stay(result)];
}
