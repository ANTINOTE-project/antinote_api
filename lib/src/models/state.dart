import 'package:antinote_api/src/helpers/enum_id.dart';

/// This is used when sending edits to the remote. The entire object should be
/// serialized as elements / element lists that would have edit states, and an
/// algorithm simply figures out what to send to the remote. TODO
enum ElementState implements EnumId {
  none(0),
  creation(1),
  edit(2),
  deletion(3),
  editChildren(4);

  @override
  final int id;

  const ElementState(this.id);
}
