import 'package:antinote/src/helpers/enum_id.dart';

enum NewsDisplayMode implements EnumId {
  reception(0),
  diffusion(1),
  draft(2),
  template(3);

  @override
  final int id;

  const NewsDisplayMode(this.id);
}
