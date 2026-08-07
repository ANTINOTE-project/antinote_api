import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/models/notification/notification.dart';

final class const NotificationCategory({
  required final String label,
  required final String identifier,
  required final List<Notification> notifications,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    label: nav.get('L'),
    identifier: nav.get('ident'),
    notifications: nav.getLM('liste').mapL((e) => Notification.decode(e)),
  );
}

final class const NotificationCenter({
  required final int totalCount,
  required final List<NotificationCategory> notifications,
}) {
  factory decode(Map<String, dynamic> nav) => .new(
    totalCount: nav.get('nbNotifs'),
    notifications: nav.getLM('liste').mapL((e) => .decode(e)),
  );
}
