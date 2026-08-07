import 'package:antinote_api/src/helpers/enum_id.dart';

enum SessionAccessType implements EnumId {
  account(0),
  accountConnection(1),
  directConnection(2),
  tokenAccountConnection(3),
  tokenDirectConnection(4),
  cookieConnection(5);

  @override
  final int id;

  const SessionAccessType(this.id);
}
