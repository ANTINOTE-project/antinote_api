import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/notebook/entry/entry.dart';
import 'package:antinote/src/models/notebook/homework/set.dart';
import 'package:antinote/src/models/notebook/resource/set.dart';

final class const NotebookPage({
  required final List<NotebookEntry> entries,
  required final PedagogicalResourceSet? resourceSet,
  required final Map<String, dynamic>? numericResourceSet,
  required final NotebookHomeworkSet? homeworkSet,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    entries:
        nav.mGetLM('ListeCahierDeTextes')?.mapL((e) => .decode(e)) ??
        List.empty(growable: false),
    resourceSet: nav
        .mGetM('ListeRessourcesPedagogiques')
        .inn((value) => .decode(value)),
    numericResourceSet: nav.mGetM('ListeRessourcesNumeriques'),
    homeworkSet: nav
        .mGetLM('ListeTravauxAFaire')
        .inn((value) => .decode(value)),
  );
}
