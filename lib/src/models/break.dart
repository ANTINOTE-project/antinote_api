import 'package:antinote/src/helpers/json.dart';

final class Break {
  final String name;
  final int daySlot;

  const Break({required this.name, required this.daySlot});
}

extension AsBreak on MapJsonNavigator {
  Break asBreak() => Break(name: get('L'), daySlot: get('place'));
}
