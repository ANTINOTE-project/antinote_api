import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/grades/page.dart';
import 'package:antinote/src/models/period.dart';

final class const LatestGradesPageAccessor({required final Period period})
    extends StatelessAccessor<LatestGradesPage> {
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
            cancellationSignal: cancellationSignal,
            dataSec: {
              session.stack.vocab.data: {
                'Periode': {'G': 2, 'N': period.id, 'L': period.name},
              },
            },
            name: 'DernieresNotes',
          ),
        )
        .resultCompleter
        .future
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<LatestGradesPage> interpretStateless(
    MapJsonNavigator<dynamic> nav,
  ) => .decode(nav);

  @override
  List<VisualIdMixin> store(LatestGradesPage result) => [
    ?result.period,
    ...?result.services,
    ...result.exams,
  ];
}
