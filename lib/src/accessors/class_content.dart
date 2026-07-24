import 'dart:async';

import 'package:antinote/antinote.dart';

class ClassContentAccessor
    extends StatefulAccessor<List<Class>, RemoteSession> {
  final bool withStudentList;
  final bool withStudentCount;

  final Class classToAccess;
  final UserResource resource;

  const ClassContentAccessor({
    this.withStudentList = false,
    this.withStudentCount = false,
    required this.classToAccess,
    required this.resource,
  });

  @override
  bool get exclusiveFriendly => true;

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
    MapJsonNavigator<dynamic> nav,
    RemoteSession session,
  ) => nav.getLM('listeCours').mapL((e) => .decode(session, e));

  @override
  List<VisualIdMixin> store(List<Class> result) => result;
}
