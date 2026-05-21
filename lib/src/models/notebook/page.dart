import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/notebook/entry/entry.dart';
import 'package:antinote/src/models/notebook/homework/set.dart';
import 'package:antinote/src/models/notebook/resource/set.dart';

final class NotebookPage {
  final List<NotebookEntry> entries;
  final PedagogicalResourceSet? resourceSet;
  final MapJsonNavigator? numericResourceSet;
  final NotebookHomeworkSet? homeworkSet;

  const NotebookPage({
    required this.entries,
    required this.resourceSet,
    required this.numericResourceSet,
    required this.homeworkSet,
  });
}

extension AsNotebookPage on MapJsonNavigator {
  NotebookPage asNotebookPage() {
    return NotebookPage(
      entries:
          mGetLM('ListeCahierDeTextes')?.mapL((e) => e.asNotebookEntry()) ??
          List.empty(growable: false),
      resourceSet: mGetM(
        'ListeRessourcesPedagogiques',
      )?.asPedagogicalResourceSet(),
      numericResourceSet: mGetM('ListeRessourcesNumeriques'),
      homeworkSet: mGetLM('ListeTravauxAFaire')?.asNotebookHomeworkSet(),
    );
  }
}
