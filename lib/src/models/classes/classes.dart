library;

import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/colors.dart';
import 'package:antinote/src/helpers/datetime.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/classes/content.dart';
import 'package:antinote/src/models/classes/group.dart';
import 'package:antinote/src/models/classes/room.dart';
import 'package:antinote/src/models/notebook/entry/preview.dart';
import 'package:antinote/src/models/person.dart';
import 'package:antinote/src/models/subject/subject.dart';

part 'activity.dart';
part 'detention.dart';
part 'lesson.dart';

enum ClassType { lesson, detention, activity }

final class const ClassMessage({
  required final String id,
  required final int index,
  required final int? backgroundColor,
  required final String? notes,
  required final DateTime startDate,
  required final DateTime endDate,
  required final int blockLength,
  required final int blockSlot,
  required final int weekNumber,
  required final String? studentCountString,
}) {
  factory decode(RemoteSession session, Map<String, dynamic> nav, int index) {
    final startDate = nav.get<DateTime>('DateDuCours');
    final int blockSlot = nav.get('place');
    final int blockLength = nav.get('duree');
    DateTime endDate;

    if (nav.get('DateDuCoursFin') != null) {
      endDate = nav.get('DateDuCoursFin');
    } else {
      final position =
          blockSlot % session.instance.slotsPerDay + blockLength - 1;
      final timings = position.asTimings(session);

      endDate = startDate.copyWith(hour: timings.hour, minute: timings.minute);
    }

    return .new(
      id: nav.get('N'),
      index: index,
      backgroundColor: nav.get<String?>('CouleurFond')?.asRGB(),
      notes: nav.get('memo'),
      startDate: startDate,
      endDate: endDate,
      blockLength: blockLength,
      blockSlot: blockSlot,
      weekNumber:
          nav.get('numeroSemaine') ?? startDate.toRemoteWeekNumber(session),
      studentCountString: nav.get('strNbEleves'),
    );
  }
}

sealed class const Class({
  required final String id,
  required final int index,
  required final int? backgroundColor,
  required final DateTime startDate,
  required final DateTime endDate,
  required final int blockLength,
  required final int blockSlot,
  required final String? notes,
  required final int weekNumber,
  required final String? studentCountString,
}) with VisualIdMixin {
  factory decode(RemoteSession session, Map<String, dynamic> nav, int index) {
    final classMessage = ClassMessage.decode(session, nav, index);

    return switch (nav) {
      _ when nav.getB('estSortiePedagogique') => Activity.decode(
        classMessage,
        nav,
      ),
      _ when nav.getB('estRetenue') => Detention.decode(classMessage, nav),
      _ => Lesson.decode(classMessage, nav),
    };
  }

  ClassType get type;

  bool get canceled;

  String? get status;

  List<ClassContent> get contents;

  @override
  String toString() =>
      '$id from ${startDate.toString()} -> ${endDate.toString()} (w$weekNumber)';

  @override
  CacheType? get cacheType => .CLAZZ;

  @override
  List<VisualNavigator> get toStore => [
    for (final content in contents)
      if (content.value is VisualIdMixin && content.navigate != null)
        .new(exchanger: content.navigate!, value: content.value),
  ];
}
