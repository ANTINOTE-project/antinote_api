import 'package:antinote_api/src/helpers/json.dart';

final class const ReportMention({
  required final String name,
  required final int sortOrder,
}) {
  factory decode(Map<String, dynamic> nav) =>
      .new(name: nav.get('L'), sortOrder: nav.get('P'));
}
