import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/models/domain.dart';
import 'package:antinote/src/models/news/display_mode.dart';
import 'package:antinote/src/models/news/page.dart';

final class const NewsPageAccessor({required final List<NewsDisplayMode> modes})
    extends StatelessAccessor<NewsPage> {
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
  FutureOr<NewsPage> interpretStateless(Map<String, dynamic> nav) =>
      .decode(nav);

  @override
  List<VisualNavigator> store(NewsPage result) => [.stay(result)];
}
