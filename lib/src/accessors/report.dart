import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/period.dart';
import 'package:antinote/src/models/report/report.dart';

/// WARNING! The behavior of this function changes depending on which tab your
/// signature currently is!
class ReportAccessor extends StatelessAccessor<BaseReport> {
  final Period period;

  const ReportAccessor({required this.period});

  @override
  bool get exclusiveFriendly => true;

  @override
  FutureOr<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) => stack
      .post(
        Call.function(
          cancellationSignal: cancellationSignal,
          dataSec: {
            stack.vocab.data: {
              'classe': {},
              'eleve': {},
              'periode': {'G': 2, "L": period.name, 'N': period.id},
            },
          },
          name: 'PageBulletins',
        ),
      )
      .resultCompleter
      .future
      .thenField(stack.vocab.data);

  @override
  FutureOr<BaseReport> interpretStateless(MapJsonNavigator<dynamic> nav) =>
      nav.asReport();

  @override
  List<VisualIdMixin> store(BaseReport result) => []; // TODO: Populate this.
}
