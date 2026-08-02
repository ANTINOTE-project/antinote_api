import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/call/call.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/models/period.dart';
import 'package:antinote/src/models/report/report.dart';

enum ReportSection { student, clazz }

final class const ReportAccessor({
  required final ReportSection section,
  required final Period period,
}) extends Accessor<BaseReport> {
  @override
  bool get exclusiveFriendly => true;

  @override
  int? get page => switch (section) {
    .student => 13,
    .clazz => 41,
  };

  @override
  FutureOr<Map<String, dynamic>> access(
    RemoteSession session,
    Completer<void>? cancellationSignal,
  ) => session.stack
      .post(
        .function(
          cancellationSignal: cancellationSignal,
          dataSec: {
            session.stack.vocab.data: {
              'classe': {},
              'eleve': {},
              'periode': {'G': 2, "L": period.name, 'N': period.id},
            },
          },
          name: 'PageBulletins',
        ),
      )
      .thenField(session.stack.vocab.data);

  @override
  FutureOr<BaseReport> interpret(
    Map<String, dynamic> nav,
    RemoteSession session,
  ) => .decode(nav);

  @override
  List<VisualNavigator> store(BaseReport result) => []; // TODO: Populate this.
}
