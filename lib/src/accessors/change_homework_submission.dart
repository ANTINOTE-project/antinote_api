import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/state.dart';

final class const ChangeHomeworkSubmissionAccessor({
  required final String homeworkId,
  required final String fileId,
  required final String filename,
}) extends StatelessAccessor<void> {
  static String callName = 'SaisieTAFARendreEleve';

  @override
  bool get exclusiveFriendly => false;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    session.stack.nextOrder(OrderBehavior.idCreation);
    return session.stack
        .post(
          .function(
            cancellationSignal: cancellationSignal,
            dataSec: {
              session.stack.vocab.data: {
                'listeFichiers': [
                  {
                    'E': ElementState.creation,
                    'G': 1,
                    'L': filename,
                    'N': session.stack.order(OrderBehavior.idCreation),
                    'idFichier': fileId,
                    'TAF': {'N': homeworkId},
                  },
                ],
              },
            },
            name: callName,
          ),
        )
        .resultCompleter
        .future;
  }

  @override
  FutureOr<void> interpretStateless(MapJsonNavigator<dynamic> nav) {
    assert(
      nav.mGetM('RapportSaisie')?.isNotEmpty ?? true,
      'Update request unsuccessful',
    );
  }

  @override
  List<VisualIdMixin> store(void result) => [];
}
