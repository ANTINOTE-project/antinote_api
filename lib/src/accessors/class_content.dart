import 'dart:async';

import 'package:antinote/antinote.dart';

class ClassContentAccessor
    extends StatefulAccessor<List<Class>, PronoteSession> {
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
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) {
    return stack
        .post(
          .function(
            cancellationSignal: cancellationSignal,
            dataSec: {
              stack.vocab.data: {
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
        .thenField(stack.vocab.data);
  }

  @override
  FutureOr<PronoteSession> collectState(PronoteSession session) => session;

  @override
  FutureOr<List<Class>> interpret(
    MapJsonNavigator<dynamic> nav,
    PronoteSession session,
  ) => nav.getLM('listeCours').mapL((e) => e.asClass(session));

  @override
  List<VisualIdMixin> store(List<Class> result) => result;
}
