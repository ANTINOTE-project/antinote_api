import 'dart:async';
import 'dart:core';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:meta/meta.dart';

@immutable
abstract class const StatefulAccessor<R, S>() {
  FutureOr<S> collectState(RemoteSession session);

  bool get exclusiveFriendly;

  bool get sensitiveResponse => false;

  int? get page;

  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  );

  FutureOr<R> interpret(Map<String, dynamic> nav, S state);

  List<VisualIdMixin> store(R result);

  Future<R> fetch(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) async {
    if (page != null) {
      await session.ensurePage(page!);
    }

    final accessed = await access(session, cancellationSignal);
    final interpreted = await interpret(accessed, await collectState(session));

    session.updateCache(store(interpreted), accessed, sensitiveResponse);

    return interpreted;
  }
}

abstract class const StatelessAccessor<R>() extends StatefulAccessor<R, void> {
  FutureOr<R> interpretStateless(Map<String, dynamic> nav);

  @override
  FutureOr<R> interpret(Map<String, dynamic> nav, void state) =>
      interpretStateless(nav);

  @override
  Future<R> fetch(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) async {
    if (page != null) {
      await session.ensurePage(page!);
    }

    final accessed = await access(session, cancellationSignal);
    final interpreted = await interpretStateless(accessed);

    session.updateCache(store(interpreted), accessed, sensitiveResponse);

    return interpreted;
  }

  @override
  Future<void> collectState(RemoteSession session) => Future.value(null);
}
