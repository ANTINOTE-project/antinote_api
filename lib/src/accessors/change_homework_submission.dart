import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/state.dart';

class ChangeHomeworkSubmissionAccessor extends StatelessAccessor<void> {
  final String homeworkId;
  final String fileId;
  final String filename;

  const ChangeHomeworkSubmissionAccessor({
    required this.homeworkId,
    required this.fileId,
    required this.filename,
  });

  static String callName = 'SaisieTAFARendreEleve';

  @override
  bool get exclusiveFriendly => false;

  @override
  FutureOr<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) {
    stack.nextOrder(OrderBehavior.idCreation);
    return stack
        .post(
          Call.function(
            cancellationSignal: cancellationSignal,
            dataSec: {
              stack.vocab.data: {
                'listeFichiers': [
                  {
                    'E': PronoteState.creation,
                    'G': 1,
                    'L': filename,
                    'N': stack.order(OrderBehavior.idCreation),
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
  FutureOr<void> interpretStateless(MapJsonNavigator<dynamic> nav) => null;

  @override
  List<VisualIdMixin> store(void result) => [];
}
