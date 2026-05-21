import 'package:antinote/src/helpers/json.dart';

final class NotificationPreviewState {
  final int notificationCount;
  final List<NotificationPreview> notifications;
  final bool refreshMessages;

  const NotificationPreviewState({
    required this.notificationCount,
    required this.notifications,
    required this.refreshMessages,
  });
}

class NotificationPreview {
  final int count;
  final int tab;

  const NotificationPreview({required this.count, required this.tab});
}

extension AsNotificationPreview on MapJsonNavigator {
  NotificationPreview asNotificationPreview() {
    return NotificationPreview(tab: get('onglet'), count: get('nb'));
  }
}
