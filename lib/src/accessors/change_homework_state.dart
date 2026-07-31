import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/homework/homework.dart';
import 'package:antinote/src/models/state.dart';

final class const ChangeHomeworkStateAccessor({
  required final Map<Homework, bool?> homeworksToUpdate,
}) extends StatelessAccessor<void> {
  @override
  bool get exclusiveFriendly => false;

  @override
  // Can be either in the home page or the homework page
  int? get page => null;

  @override
  Future<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
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
  FutureOr<void> interpretStateless(Map<String, dynamic> nav) {
    assert(
      nav.mGetM('RapportSaisie')?.isNotEmpty ?? true,
      'Update request unsuccessful',
    );
  }

  @override
  List<VisualIdMixin> store(void result) => [];
}
