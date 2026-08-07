import 'dart:async';

import 'package:antinote_api/antinote_api.dart';

final class const ClassContentAccessor({
  required final bool withStudentList,
  required final bool withStudentCount,

  required final Class classToAccess,
  required final UserResource resource,
}) extends Accessor<List<Class>> {
  @override
  bool get exclusiveFriendly => true;

  @override
  // Can be in the home page or the timetable.
  int? get page => null;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
            cancellationSignal: cancellationSignal,
            dataSec: {
              session.stack.vocab.data: {
                'avecListeEleves': withStudentList,
                'avecNbEleves': withStudentCount,
                'cours': {'G': classToAccess.type.index, 'N': classToAccess.id},
                'numeroSemaine': classToAccess.weekNumber,
                'ressource': resource.toRaw(),
              },
            },
            name: 'FicheCours',
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<List<Class>> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) => nav
      .getLM('listeCours')
      .indexed
      .map((e) => Class.decode(session, e.$2, e.$1))
      .toList(growable: false);

  @override
  List<VisualNavigator> store(List<Class> result) => [
    for (final clazz in result)
      .indexed(clazz, field: 'listeCours', index: clazz.index),
  ];
}
