import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/homework/homework.dart';

final class NotebookHomeworkSet {
  final List<Homework> homeworks;

  const NotebookHomeworkSet({required this.homeworks});
}

extension AsNotebookHomeworkSet on ListJsonNavigator<MapJsonNavigator> {
  NotebookHomeworkSet asNotebookHomeworkSet() {
    return NotebookHomeworkSet(homeworks: mapL((e) => e.asHomework()));
  }
}
