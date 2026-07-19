import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/homework/homework.dart';
import 'package:antinote/src/models/state.dart';

class ChangeHomeworkStateAccessor extends StatelessAccessor<void> {
  const ChangeHomeworkStateAccessor({required this.homeworksToUpdate});

  final Map<Homework, bool?> homeworksToUpdate;

  @override
  bool get exclusiveFriendly => false;

  @override
  Future<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          Call.function(
            name: 'SaisieTAFFaitEleve',
            dataSec: {
              session.stack.vocab.data: {
                'listeTAF': [
                  for (final homework in homeworksToUpdate.entries)
                    {
                      'G': homework.key.type,
                      'E': ElementState.edit,
                      'N': homework.key.id,
                      'TAFFait': homework.value ?? homework.key.isDone,
                    },
                ],
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<void> interpretStateless(MapJsonNavigator nav) {
    if (nav.mGetM('RapportSaisie')?.isNotEmpty ?? false) {
      print(
        'RapportSaisie in SaisieTAFFaitEleve is not empty!!! ${nav.toString()}',
      );
    }
  }

  @override
  List<VisualIdMixin> store(void result) => [];
}
