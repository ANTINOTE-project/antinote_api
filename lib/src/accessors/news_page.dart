import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/domain.dart';
import 'package:antinote/src/models/news/display_mode.dart';
import 'package:antinote/src/models/news/page.dart';

final class const NewsPageAccessor({required final List<NewsDisplayMode> modes})
    extends StatelessAccessor<NewsPage> {
  const NewsPageAccessor.defaultMode() : this(modes: const [.reception]);

  @override
  bool get exclusiveFriendly => true;

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
                'modesAffActus': {
                  '_T': 26,
                  'V': modes.map((e) => e.id).asDomain(),
                },
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
  FutureOr<NewsPage> interpretStateless(MapJsonNavigator nav) => .decode(nav);

  @override
  List<VisualIdMixin> store(NewsPage result) => [
    ...result.categories,
    for (final collection in result.collections) ...collection.news,
  ];
}
