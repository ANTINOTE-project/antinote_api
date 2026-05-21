library;

import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/colors.dart';
import 'package:antinote/src/helpers/datetime.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/session.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/classes/group.dart';
import 'package:antinote/src/models/classes/room.dart';
import 'package:antinote/src/models/notebook/entry/preview.dart';
import 'package:antinote/src/models/person.dart';
import 'package:antinote/src/models/subject/subject.dart';

part 'activity.dart';
part 'detention.dart';
part 'lesson.dart';

enum ClassType { lesson, detention, activity }

final class ClassMessage {
  final String id;
  final int? backgroundColor;
  final String? notes;
  final DateTime startDate;
  final DateTime endDate;
  final int blockLength;
  final int blockSlot;
  final int weekNumber;

  const ClassMessage({
    required this.id,
    required this.backgroundColor,
    required this.notes,
    required this.startDate,
    required this.endDate,
    required this.blockLength,
    required this.blockSlot,
    required this.weekNumber,
  });
}

extension AsClassMessage on MapJsonNavigator {
  ClassMessage asClassMessage(PronoteSession session) {
    final startDate = get<DateTime>('DateDuCours');
    final int blockSlot = get('place');
    final int blockLength = get('duree');
    DateTime endDate;

    if (get('DateDuCoursFin') != null) {
      endDate = get('DateDuCoursFin');
    } else {
      final position =
          blockSlot % session.instance.slotsPerDay + blockLength - 1;
      final timings = position.asTimings(session);

      endDate = startDate.copyWith(hour: timings.hour, minute: timings.minute);
    }

    return ClassMessage(
      id: get('N'),
      backgroundColor: get<String?>('CouleurFond')?.asRGB(),
      notes: get('memo'),
      startDate: startDate,
      endDate: endDate,
      blockLength: blockLength,
      blockSlot: blockSlot,
      weekNumber:
          get('numeroSemaine') ?? startDate.toPronoteWeekNumber(session),
    );
  }
}

sealed class Class with VisualIdMixin {
  ClassType get type;

  final String id;
  final int? backgroundColor;
  final DateTime startDate;
  final DateTime endDate;
  final int blockLength;
  final int blockSlot;
  final String? notes;
  final int weekNumber;

  const Class({
    required this.id,
    required this.backgroundColor,
    required this.startDate,
    required this.endDate,
    required this.blockLength,
    required this.blockSlot,
    required this.notes,
    required this.weekNumber,
  });

  @override
  String toString() =>
      '$id from ${startDate.toString()} -> ${endDate.toString()} (w$weekNumber)';

  @override
  CacheType? get cacheType => .CLAZZ;
}

extension AsClass on MapJsonNavigator {
  Class asClass(PronoteSession session) {
    final classMessage = asClassMessage(session);

    return switch (this) {
      {'estSortiePedagogique': final isActivity} when isActivity != null =>
        Activity.decode(classMessage, this),
      {'estRetenue': final isDetention} when isDetention != null =>
        Detention.decode(classMessage, this),
      _ => Lesson.decode(classMessage, this),
    };
  }
}
