import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/models/workspace/type.dart';
import 'package:antinote/src/models/workspace/workspace.dart';

// TODO: Make notification parsing exhaustive...
final class Notification {
  final int type;
  final int action;
  final String id;
  final String title;
  final String message;
  final int counter;
  final Set<int> modalities;

  final DateTime? date;
  final DateTime? expirationDate;
  final bool? buttonClick;
  final bool? notificationClick;
  final List<int>? tabList;
  final String? documentModelId;

  const Notification({
    required this.type,
    required this.action,
    required this.id,
    required this.title,
    required this.message,
    required this.counter,
    required this.modalities,

    required this.date,
    required this.expirationDate,
    required this.buttonClick,
    required this.notificationClick,
    required this.tabList,
    required this.documentModelId,
  });

  factory Notification.decode(MapJsonNavigator nav) {
    return Notification(
      type: nav.get('type'),
      action: nav.get('action'),
      id: nav.get('id'),
      title: nav.get('titre'),
      message: nav.get('message'),
      counter: nav.get('compteur'),
      modalities: nav.get('modalites'),
      date: nav.get('date'),
      expirationDate: nav.get('dateExpiration'),
      buttonClick: nav.get('onBtnClick') ?? true,
      notificationClick: nav.get('onNotifClick') ?? true,
      tabList: nav.mGetL<int>('navOnglets'),
      documentModelId: nav.mGetM('modeleDocument')?.get('N'),
    );
  }

  int tabLocationForNotification(RemoteSession session) {
    if (tabList != null) {
      for (final tab in tabList!) {
        if (session.user.hasAccessToTab(tab)) {
          return tab;
        }
      }
    }

    return tabLocationByNotificationId(session.instance.workspace) ?? -1;
  }

  int? tabLocationByNotificationId(Workspace workspace) {
    return switch (id) {
      'insh_IdDiscussions' => 131,
      'insh_IdCasiers' => 148,
      'insh_IdInformations' => 8,
      'insh_IdSujetsForum' => 275,
      'insh_IdDemandeRemplacements' => 285,
      'insh_IdDocumentASigner' =>
        workspace.type.categories.contains(WorkspaceCategory.hasNoLocker)
            ? 148
            : 104,
      _ => null,
    };
  }
}
