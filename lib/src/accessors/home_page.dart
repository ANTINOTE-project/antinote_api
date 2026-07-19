import 'dart:async';

import 'package:antinote/antinote.dart';

class HomePageAccessor({required final List<HomePageModule> modules})
    extends StatefulAccessor<HomePage, RemoteSession> {
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
            name: 'PageAccueil',
            dataSec: {
              session.stack.vocab.data: {
                for (final module in modules) ...module.data(session),

                'widgets': modules.mapL((e) => e.widget.id),
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
  FutureOr<HomePage> interpret(MapJsonNavigator nav, RemoteSession state) =>
      HomePage.decode(nav, state);

  @override
  List<VisualIdMixin> store(HomePage result) => [result];
}

class HomePageModule({
  required final HomePageWidgetType widget,
  required final Map<String, dynamic> Function(RemoteSession session) data,
});
