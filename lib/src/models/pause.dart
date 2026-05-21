import 'package:antinote/src/helpers/json.dart';

final class Pause {
  final String label;
  final int slot;

  const Pause({required this.label, required this.slot});
}

extension AsPause on MapJsonNavigator {
  Pause asPause() {
    return Pause(label: get('L'), slot: get('place'));
  }
}
