import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/news/display_mode.dart';
import 'package:antinote/src/models/news/news.dart';
import 'package:antinote/src/models/news/page.dart';

final class const NewsContentAccessor({
  required final NewsDisplayMode mode,
  required final News baseNews,
}) extends StatelessAccessor<NewsContent> {
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
                // Only those three fields are actually required.
                'actualite': {
                  'N': baseNews.id,
                  'public': baseNews.recipient.toJson(),
                  'genrePublic': baseNews.recipientType,
                },
                'genreRequeteActualite': NewsPageRequestType.details.id,
                'modeAffActu': mode.id,
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<NewsContent> interpretStateless(Map<String, dynamic> nav) =>
      .decode(nav);

  @override
  List<VisualIdMixin> store(NewsContent result) => [];
}
