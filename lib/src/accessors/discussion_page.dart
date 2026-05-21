import 'dart:async';

import 'package:antinote/src/accessors/accessors.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/network_stack.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/discussion/page.dart';

class DiscussionPageAccessor extends StatelessAccessor<DiscussionPage> {
  final bool showRead;
  final bool withMessages;

  const DiscussionPageAccessor({
    required this.showRead,
    required this.withMessages,
  });

  @override
  FutureOr<Map<String, dynamic>> access(
    NetworkStack stack,
    Completer<void>? cancellationSignal,
  ) {
    return stack
        .post(
          Call.function(
            name: 'ListeMessagerie',
            dataSec: {
              stack.vocab.data: {
                'avecLu': showRead,
                'avecMessage': withMessages,
              },
            },
            cancellationSignal: cancellationSignal,
          ),
        )
        .resultCompleter
        .future
        .thenField(stack.vocab.data);
  }

  @override
  FutureOr<DiscussionPage> interpretStateless(MapJsonNavigator nav) =>
      nav.asDiscussionPage();

  @override
  List<VisualIdMixin> store(DiscussionPage result) => [...result.discussions];
}
