import 'dart:async';

import 'package:antinote/antinote.dart';

final class const ClassContentAccessor({
  required final bool withStudentList,
  required final bool withStudentCount,

  required final Class classToAccess,
  required final UserResource resource,
}) extends StatefulAccessor<List<Class>, RemoteSession> {
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
        .resultCompleter
        .future
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<RemoteSession> collectState(RemoteSession session) => session;

  @override
  FutureOr<List<Class>> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) => nav.getLM('listeCours').mapL((e) => .decode(session, e));

  @override
  List<VisualIdMixin> store(List<Class> result) => result;
}
