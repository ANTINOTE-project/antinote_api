import 'package:antinote/src/helpers/json.dart';

final class TimeSlot {
  final int index;
  final String label;
  final bool active;

  final ({int hour, int minute}) timing;

  const TimeSlot({
    required this.index,
    required this.label,
    required this.active,

    required this.timing,
  });
}

extension AsTimeSlot on MapJsonNavigator {
  TimeSlot asTimeSlot() {
    final [hour, minute] = get<String>(
      'L',
    ).split('h').sublist(0, 2).mapL(int.parse);
    return TimeSlot(
      index: get('G'),
      label: get('L'),
      active: get('A') ?? true,
      timing: (hour: hour, minute: minute),
    );
  }
}
