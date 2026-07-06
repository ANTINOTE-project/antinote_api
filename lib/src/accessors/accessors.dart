import 'dart:async';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:meta/meta.dart';

@immutable
abstract class StatefulAccessor<R, S> {
  FutureOr<S> collectState(RemoteSession session);

  bool get exclusiveFriendly;

  FutureOr<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  );

  FutureOr<R> interpret(MapJsonNavigator nav, S state);

  List<VisualIdMixin> store(R result);

  Future<R> fetch(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) async {
    final accessed = await access(session.stack, cancellationSignal);
    final interpreted = await interpret(accessed, await collectState(session));

    session.updateCache(store(interpreted), accessed);

    return interpreted;
  }

  const StatefulAccessor();
}

abstract class StatelessAccessor<R> extends StatefulAccessor<R, void> {
  FutureOr<R> interpretStateless(MapJsonNavigator nav);

  @override
  FutureOr<R> interpret(MapJsonNavigator nav, void state) =>
      interpretStateless(nav);

  @override
  Future<R> fetch(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) async {
    final accessed = await access(session.stack, cancellationSignal);
    final interpreted = await interpretStateless(accessed);

    session.updateCache(store(interpreted), accessed);

    return interpreted;
  }

  @override
  Future<void> collectState(RemoteSession session) => Future.value(null);

  const StatelessAccessor();
}
