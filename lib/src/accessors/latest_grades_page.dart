import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/models/grades/page.dart';
import 'package:antinote/src/models/period.dart';

final class const LatestGradesPageAccessor({required final Period period})
    extends StatelessAccessor<LatestGradesPage> {
  @override
  bool get exclusiveFriendly => true;

  @override
  int? get page => 198;

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) {
    return session.stack
        .post(
          .function(
            cancellationSignal: cancellationSignal,
            dataSec: {
              session.stack.vocab.data: {
                'Periode': {'G': 2, 'N': period.id, 'L': period.name},
              },
            },
            name: 'DernieresNotes',
          ),
        )
        .thenField(session.stack.vocab.data);
  }

  @override
  FutureOr<LatestGradesPage> interpretStateless(Map<String, dynamic> nav) =>
      .decode(nav);

  @override
  List<VisualNavigator> store(LatestGradesPage result) => [.stay(result)];
}
