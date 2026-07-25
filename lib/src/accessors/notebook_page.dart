import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/date.dart';
import 'package:antinote/src/models/domain.dart';
import 'package:antinote/src/models/notebook/page.dart';

final class NotebookPageAccessor extends StatelessAccessor<NotebookPage> {
  final Set<int>? weeks;
  final DateTime? date;
  final bool? onlyAccessResources;

  const NotebookPageAccessor({required Set<int> this.weeks})
    : onlyAccessResources = null,
      date = null;

  const NotebookPageAccessor.upcoming({required DateTime this.date})
    : onlyAccessResources = null,
      weeks = null;

  const NotebookPageAccessor.onlyResources({required Set<int> this.weeks})
    : onlyAccessResources = true,
      date = null;

  const NotebookPageAccessor.noPedagogicalResources({
    required Set<int> this.weeks,
  }) : onlyAccessResources = false,
       date = null;

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
            name: 'PageCahierDeTexte',
            dataSec: {
              session.stack.vocab.data: {
                if (weeks != null) 'domaine': {'_T': 8, 'V': weeks!.asDomain()},
                if (date != null) 'date': {'_T': 7, 'V': date!.asRemoteDate()},
                if (onlyAccessResources == true) 'estRequeteRP': true,
                if (onlyAccessResources == false) 'sansRequeteRP': true,
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
  FutureOr<NotebookPage> interpretStateless(MapJsonNavigator nav) =>
      .decode(nav);

  @override
  List<VisualIdMixin> store(NotebookPage result) => [
    ...result.entries,
    ...?result.homeworkSet?.homeworks,
    ...?result.resourceSet?.entries,
  ];
}
