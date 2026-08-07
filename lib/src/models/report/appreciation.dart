import 'package:antinote_api/src/helpers/json.dart';

final class const ReportAppreciation({
  required final String? name,
  required final String? id,
  required final int type,
  required final String? title,
  required final bool? closed,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    name: nav.get('L'),
    id: nav.get('N'),
    type: nav.get('G'),
    title: nav.get('Intitule'),
    closed: nav.get('cloture'),
  );
}
