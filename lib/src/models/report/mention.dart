import 'package:antinote/src/helpers/json.dart';

final class ReportMention {
  final String name;
  final int sortOrder;

  const ReportMention({required this.name, required this.sortOrder});
}

extension AsReportMention on MapJsonNavigator {
  ReportMention asReportMention() {
    return ReportMention(name: get('L'), sortOrder: get('P'));
  }
}
