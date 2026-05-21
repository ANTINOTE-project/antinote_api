import 'package:antinote/src/helpers/json.dart';

final class ReportAppreciation {
  final String? name;
  final String? id;
  final int type;
  final String? title;
  final bool? closed;

  const ReportAppreciation({
    required this.name,
    required this.id,
    required this.type,
    required this.title,
    required this.closed,
  });
}

extension AsReportAppreciation on MapJsonNavigator {
  ReportAppreciation asReportAppreciation() {
    return ReportAppreciation(
      name: get('L'),
      id: get('N'),
      type: get('G'),
      title: get('Intitule'),
      closed: get('cloture'),
    );
  }
}
