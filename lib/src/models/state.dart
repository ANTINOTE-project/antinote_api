import 'package:antinote/src/helpers/enum_id.dart';

enum ElementState implements EnumId {
  none(0),
  creation(1),
  edit(2),
  deletion(3),

  /// Not sure about the english version of this one (it's supposed to be FilsModification)
  editChildren(4);

  @override
  final int id;

  const ElementState(this.id);
}
