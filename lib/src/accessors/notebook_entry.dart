import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/notebook/entry/entry.dart';
import 'package:antinote/src/models/notebook/page.dart';

class NotebookEntryAccessor extends StatelessAccessor<NotebookEntry> {
  final String entryId;

  const NotebookEntryAccessor({required this.entryId});

  @override
  bool get exclusiveFriendly => true;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          Call.function(
            name: 'donneesContenusCDT',
            dataSec: {
              session.stack.vocab.data: {
                'cahierDeTextes': {'N': entryId},
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .resultCompleter
        .future
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<NotebookEntry> interpretStateless(MapJsonNavigator nav) {
    assert(
      nav.getLM('ListeCahierDeTextes').length == 1,
      'Got multiple entries from function call donnesContenusCDT',
    );

    return nav.asNotebookPage().entries.single;
  }

  @override
  List<VisualIdMixin> store(NotebookEntry result) => [
    result,
    result.subject,
    ...result.groupList,
    ...result.teacherList,
    ...result.contentList,
  ];
}
