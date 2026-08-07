import 'dart:async';

import 'package:antinote_api/src/accessors/accessors.dart';
import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/network_stack.dart';
import 'package:antinote_api/src/helpers/session.dart';
import 'package:antinote_api/src/models/notebook/entry/entry.dart';
import 'package:antinote_api/src/models/notebook/page.dart';

final class const NotebookEntryAccessor({required final String entryId})
    extends Accessor<NotebookEntry> {
  @override
  bool get exclusiveFriendly => true;

  @override
  // Can be in the home page or in the notebook page (and maybe the timetable).
  int? get page => null;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
            name: 'donneesContenusCDT',
            dataSec: {
              session.stack.vocab.data: {
                'cahierDeTextes': {'N': entryId},
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<NotebookEntry> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) {
    assert(
      nav.getLM('ListeCahierDeTextes').length == 1,
      'Got multiple (or no) entries from function call donnesContenusCDT',
    );

    return NotebookPage.decode(nav).entries.single;
  }

  @override
  List<VisualNavigator> store(NotebookEntry result) => [
    .new(
      exchanger: (nav) => nav.getLM('ListeCahierDeTextes').getM(0),
      value: result,
    ),
  ];
}
