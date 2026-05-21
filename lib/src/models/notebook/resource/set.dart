import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/notebook/resource/entry.dart';
import 'package:antinote/src/models/subject/subject.dart';

final class PedagogicalResourceSet {
  final List<NotebookResourceEntry> entries;
  final List<Subject> subjects;

  const PedagogicalResourceSet({required this.entries, required this.subjects});
}

extension AsPedagogicalResourceSet on MapJsonNavigator {
  PedagogicalResourceSet asPedagogicalResourceSet() {
    final subjects = getLM('listeMatieres').mapL((e) => e.asSubject());

    return PedagogicalResourceSet(
      entries: getLM(
        'listeRessources',
      ).mapL((e) => e.asNotebookResourceEntry(subjects)),
      subjects: subjects,
    );
  }
}
