import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/homework/homework.dart';

final class const NotebookHomeworkSet({
  required final List<Homework> homeworks,
}) {
  factory decode(List<Map<String, dynamic>> nav) =>
      .new(homeworks: nav.mapL((e) => .decode(e)));
}
