import 'dart:async';

import 'package:antinote/antinote.dart';

final class const NewsContentAccessor({
  required final NewsDisplayMode mode,
  required final News baseNews,
}) extends Accessor<NewsContent> {
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
  FutureOr<NewsContent> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) {
    assert(
      nav.getM('detailsActualite').length == 1,
      'Other unexpected fields were found in the news details response.',
    );

    return .decode(nav);
  }

  @override
  List<VisualNavigator> store(NewsContent result) => [];
}
