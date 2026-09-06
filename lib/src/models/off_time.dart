import 'dart:typed_data';

import 'package:antinote_api/antinote_api.dart';
import 'package:antinote_api/src/helpers/localization.dart';

typedef OnTimePeriod = ({DateTime start, DateTime end});

final class const OffTimeParameters({
  required final bool gradesPauseActive,
  required final int gradesHour,
  required final int gradesDelay,

  required final bool homeworkPauseActive,
  required final int homeworkStartHour,
  required final int homeworkEndHour,

  required final bool communicationPauseActive,
  required final Set<String> communicationRawBusinessDays,
  required final Set<int> communicationBusinessDays,
  required final Set<String> communicationRawWeekend,
  required final Set<int> communicationWeekend,
  required final bool communicationHolidays,
  required final int communicationStartHour,
  required final int communicationEndHour,
}) with VisualIdMixin {
  factory decode(RemoteSession session, Map<String, dynamic> nav) {
    final grades = nav.mGo('notes');
    final homework = nav.mGo('taf');
    final communication = nav.mGo('messagerie');

    return OffTimeParameters(
      gradesPauseActive: grades != null,
      gradesHour: grades?.get('heurePublicationNote') ?? 0,
      gradesDelay:
          grades?.get('nombreJoursDecalagePublicationNote') ??
          session.instance.defaultPublicationInterval,

      homeworkPauseActive: homework != null,
      homeworkStartHour:
          homework?.get('heureDebutDesactivationPublication') ?? 0,
      homeworkEndHour: homework?.get('heureFinDesactivationPublication') ?? 0,

      communicationPauseActive: communication != null,
      communicationRawBusinessDays:
          communication?.getL<String>('listeJoursOuvresDeconnexion').toSet() ??
          <String>{},
      communicationBusinessDays:
          communication
              ?.getL<String>('listeJoursOuvresDeconnexion')
              .map((day) => weekday(day)!)
              .toSet() ??
          {},
      communicationRawWeekend:
          communication
              ?.getL<String>('listeJoursNonOuvresDeconnexion')
              .toSet() ??
          <String>{},
      communicationWeekend:
          communication
              ?.getL<String>('listeJoursNonOuvresDeconnexion')
              .map((day) => weekday(day)!)
              .toSet() ??
          {},
      communicationHolidays:
          communication?.getB('avecJourFerieDeconnexion') ?? false,
      communicationStartHour: communication?.get('heureAvantDeconnexion') ?? 0,
      communicationEndHour: communication?.get('heureApresDeconnexion') ?? 0,
    );
  }

  @override
  CacheType? get cacheType => .UNIQUE;

  @override
  SerialObjectId? get overrideSerialId => .offPeriod;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {}

  OnTimePeriod? homeworkOnTime(Date date) {
    if (!homeworkPauseActive) {
      return (
        start: date.copyWith(hour: 0),
        end: date.add(const Duration(days: 1)),
      );
    }

    return (
      start: date.copyWith(hour: homeworkEndHour),
      end: date.copyWith(hour: homeworkStartHour),
    );
  }

  OnTimePeriod? communicationOnTime(Date date, RemoteSession session) {
    if (!communicationPauseActive) {
      return (
        start: date.copyWith(hour: 0),
        end: date.add(const Duration(days: 1)),
      );
    }

    if (communicationHolidays &&
        session.instance.holidays.any((element) => element.contains(date))) {
      return null;
    }

    if (communicationWeekend.contains(date.weekday)) {
      return null;
    }

    if (communicationBusinessDays.contains(date.weekday)) {
      return (
        start: date.copyWith(hour: communicationEndHour),
        end: date.copyWith(hour: communicationStartHour),
      );
    }

    return (
      start: date.copyWith(hour: 0),
      end: date.add(const Duration(days: 1)),
    );
  }
}
