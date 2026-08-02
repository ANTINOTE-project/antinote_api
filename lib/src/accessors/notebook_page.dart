import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/models/date.dart';
import 'package:antinote/src/models/domain.dart';
import 'package:antinote/src/models/notebook/page.dart';

enum NotebookSection { homework, resources }

final class NotebookPageAccessor extends Accessor<NotebookPage> {
  final NotebookSection section;
  final Set<int>? weeks;
  final DateTime? date;
  final bool? onlyAccessResources;

  const NotebookPageAccessor({
    required this.section,
    required Set<int> this.weeks,
  }) : onlyAccessResources = null,
       date = null;

  const NotebookPageAccessor.upcoming({
    required this.section,
    required DateTime this.date,
  }) : onlyAccessResources = null,
       weeks = null;

  const NotebookPageAccessor.onlyResources({
    required this.section,
    required Set<int> this.weeks,
  }) : onlyAccessResources = true,
       date = null;

  const NotebookPageAccessor.noPedagogicalResources({
    required this.section,
    required Set<int> this.weeks,
  }) : onlyAccessResources = false,
       date = null;

  @override
  bool get exclusiveFriendly => true;

  @override
  int? get page => switch (section) {
    .homework => 88,
    .resources => 89,
  };

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
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
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<NotebookPage> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) => .decode(nav);

  @override
  List<VisualNavigator> store(NotebookPage result) => [.stay(result)];
}
