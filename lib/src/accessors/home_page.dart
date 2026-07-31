import 'dart:async';

import 'package:antinote/antinote.dart';

final class const HomePageAccessor({
  required final List<HomePageModule>? modules,
}) extends StatefulAccessor<HomePage, RemoteSession> {
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

                if (modules != null)
                  'widgets': modules!.mapL((e) => e.widget.id),
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<RemoteSession> collectState(RemoteSession session) => session;

  @override
  FutureOr<HomePage> interpret(Map<String, dynamic> nav, RemoteSession state) =>
      HomePage.decode(nav, state);

  @override
  List<VisualIdMixin> store(HomePage result) => [result];
}

final class const HomePageModule({
  required final HomePageWidgetType widget,
  final canQuerySpecifically = false,
  required final Map<String, dynamic> Function(RemoteSession session) data,
});
