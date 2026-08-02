import 'dart:async';

import 'package:antinote/antinote.dart';

final class const HomePageAccessor({
  required final List<HomePageModule>? modules,
}) extends Accessor<HomePage> {
  @override
  bool get exclusiveFriendly => true;

  @override
  int? get page => 7;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
            name: 'PageAccueil',
            dataSec: {
              session.stack.vocab.data: {
                for (final module in modules ?? <HomePageModule>[])
                  ...module.data(session),

                if (modules != null &&
                    !modules!.any((element) => !element.canQuerySpecifically))
                  'widgets': modules!.mapL((e) => e.widget.id),
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<HomePage> interpret(Map<String, dynamic> nav, RemoteSession state) =>
      .decode(nav, state);

  @override
  List<VisualNavigator> store(HomePage result) => [.stay(result)];
}

final class const HomePageModule({
  required final HomePageWidgetType widget,

  /// Unfortunately, some widget's can't be fetched individually (functionality
  /// wasn't implemented by remote). When we need to fetch one of those widgets,
  /// we resort to fetching the whole page.
  final canQuerySpecifically = false,
  required final Map<String, dynamic> Function(RemoteSession session) data,
});
