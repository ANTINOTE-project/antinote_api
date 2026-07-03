import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/protos/antinote/session.pb.dart';

extension MergeServerSignature on ServerSignature {
  // Update signals:
  // - actualisationMessage
  // - notificationsKiosque
  // - notifications.actualisation_postForum
  // - notifications.MAJAnnulation

  // Events:
  // - notifications.dureeMAJServeur
  // - notifications.tokenOAuth2

  ServerSignature mergeWith(Map<String, dynamic> newSignature) {
    if (!isFrozen) freeze();

    return rebuild((sig) {
      if (newSignature.has('ModeExclusif')) {
        sig.exclusiveMode = newSignature.getB('ModeExclusif');
      }
      if (newSignature.has('notificationsCommunication')) {
        for (final entry in newSignature.getLM('notificationsCommunication')) {
          sig.tabNotificationCounts[entry.get('onglet')] = entry.get('nb') ?? 0;
        }
      }
      if (newSignature.has('notificationsChatVS')) {
        // TODO
      }
      if (newSignature.has('notifications')) {
        final notifs = newSignature.getM('notifications');

        if (notifs.has('compteurCentraleNotif')) {
          sig.visibleNotificationsCount = notifs.get('compteurCentraleNotif');
        }
        if (notifs.has('statutConnexion')) {
          sig.connectionStatus =
              ServerSignature_ConnectionStatus.valueOf(
                notifs.get('statusConnexion'),
              ) ??
              .AVAILABLE;
        }
      }
    })..freeze();
  }
}
