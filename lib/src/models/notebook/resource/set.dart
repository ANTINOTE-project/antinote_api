import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/notebook/resource/entry.dart';
import 'package:antinote/src/models/subject/subject.dart';

final class const PedagogicalResourceSet({
  required final List<NotebookResourceEntry> entries,
  required final List<Subject> subjects,
}) {
  factory decode(Map<String, dynamic> nav) {
    final subjects = nav
        .getLM('listeMatieres')
        .mapL<Subject>((e) => .decode(e));
    return .new(
      entries: nav.getLM('listeRessources').mapL((e) => .decode(e, subjects)),
      subjects: subjects,
    );
  }
}
