import 'dart:async';
import 'dart:core';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:meta/meta.dart';

@immutable
abstract class const Accessor<R>() {
  bool get exclusiveFriendly;

  int? get page;

  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  );

  FutureOr<R> interpret(Map<String, dynamic> nav, RemoteSession state);

  List<VisualNavigator> store(R result);

  Future<R> fetch(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) async {
    if (page != null) {
      await session.ensurePage(page!);
    }

    final accessed = await access(session, cancellationSignal);
    final interpreted = await interpret(accessed, session);

    session.updateCache(store(interpreted), accessed);

    return interpreted;
  }
}
