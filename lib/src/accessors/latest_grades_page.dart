import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/grades/page.dart';
import 'package:antinote/src/models/period.dart';

class LatestGradesPageAccessor extends StatelessAccessor<LatestGradesPage> {
  const LatestGradesPageAccessor({required this.period});

  final Period period;

  @override
  FutureOr<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) {
    return stack
        .post(
          Call.function(
            cancellationSignal: cancellationSignal,
            dataSec: {
              stack.vocab.data: {
                'Periode': {'G': 2, 'N': period.id, 'L': period.name},
              },
            },
            name: 'DernieresNotes',
          ),
        )
        .resultCompleter
        .future
        .thenField(stack.vocab.data);
  }

  @override
  FutureOr<LatestGradesPage> interpretStateless(
    MapJsonNavigator<dynamic> nav,
  ) => nav.asLatestGradesPage();

  @override
  List<VisualIdMixin> store(LatestGradesPage result) => [
    ?result.period,
    ...?result.services,
    ...result.exams,
  ];
}
