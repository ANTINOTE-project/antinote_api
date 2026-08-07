import 'dart:typed_data';

import 'package:antinote_api/src/helpers/cache.dart';
import 'package:antinote_api/src/helpers/json.dart';
import 'package:antinote_api/src/helpers/session.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';

final class const OffTimeParameters({
  required final bool gradesPublicationPauseActive,
  required final int gradesPublicationHour,
  required final int gradesPublicationDelay,

  required final bool homeworkPublicationPauseActive,
  required final int homeworkPublicationDeactivationStartHour,
  required final int homeworkPublicationDeactivationEndHour,

  required final bool communicationPauseActive,
  required final Set<String> communicationDeactivationBusinessDays,
  required final Set<String> communicationDeactivationNonBusinessDays,
  required final bool withHolidayDeactivation,
  required final int communicationDeactivationStartHour,
  required final int communicationDeactivationEndHour,
}) with VisualIdMixin {
  factory decode(RemoteSession session, Map<String, dynamic> nav) {
    final grades = nav.mGo('notes');
    final homework = nav.mGo('taf');
    final communication = nav.mGo('messagerie');

    return OffTimeParameters(
      gradesPublicationPauseActive: grades != null,
      gradesPublicationHour: grades?.get('heurePublicationNote') ?? 0,
      gradesPublicationDelay:
          grades?.get('nombreJoursDecalagePublicationNote') ??
          session.instance.defaultPublicationInterval,

      homeworkPublicationPauseActive: homework != null,
      homeworkPublicationDeactivationStartHour:
          homework?.get('heureDebutDesactivationPublication') ?? 0,
      homeworkPublicationDeactivationEndHour:
          homework?.get('heureFinDesactivationPublication') ?? 0,

      communicationPauseActive: communication != null,
      communicationDeactivationBusinessDays:
          communication?.getL<String>('listeJoursOuvresDeconnexion').toSet() ??
          <String>{},
      communicationDeactivationNonBusinessDays:
          communication
              ?.getL<String>('listeJoursNonOuvresDeconnexion')
              .toSet() ??
          <String>{},
      withHolidayDeactivation:
          communication?.getB('avecJourFerieDeconnexion') ?? false,
      communicationDeactivationStartHour:
          communication?.get('heureAvantDeconnexion') ?? 0,
      communicationDeactivationEndHour:
          communication?.get('heureApresDeconnexion') ?? 0,
    );
  }

  @override
  CacheType? get cacheType => .UNIQUE;

  @override
  SerialObjectId? get overrideSerialId => .offPeriod;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {}

  // TODO: Implement scheduling algorithm for when off periods appear.
}
