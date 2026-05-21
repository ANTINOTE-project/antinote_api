import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/notification/notification.dart';

final class NotificationCategory {
  final String label;
  final String identifier;
  final List<Notification> notifications;

  const NotificationCategory({
    required this.label,
    required this.identifier,
    required this.notifications,
  });
}

extension AsNotificationCategory on MapJsonNavigator {
  NotificationCategory asNotificationCategory() {
    return NotificationCategory(
      label: get('L'),
      identifier: get('ident'),
      notifications: getLM('liste').mapL((e) => Notification.decode(e)),
    );
  }
}

final class NotificationCenter {
  final int totalCount;
  final List<NotificationCategory> notifications;

  const NotificationCenter({
    required this.totalCount,
    required this.notifications,
  });
}

extension AsNotificationCenter on MapJsonNavigator {
  NotificationCenter asNotificationCenter() {
    return NotificationCenter(
      totalCount: get('nbNotifs'),
      notifications: getLM('liste').mapL((e) => e.asNotificationCategory()),
    );
  }
}
