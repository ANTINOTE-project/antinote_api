import 'package:antinote/src/helpers/session.dart';

class Date extends DateTime {
  Date(
    super.year, [
    super.month,
    super.day,
    super.hour,
    super.minute,
    super.second,
    super.millisecond,
    super.microsecond,
  ]);

  Date.utc(
    super.year, [
    super.month,
    super.day,
    super.hour,
    super.minute,
    super.second,
    super.millisecond,
    super.microsecond,
  ]) : super.utc();

  @override
  String toString() =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}

extension DateTimeSimplification on DateTime {
  DateTime toDay() {
    final constructor = isUtc ? Date.utc : Date.new;

    return constructor(
      year,
      month,
      day,
      0 /*hour*/,
      0 /*minute*/,
      0 /*second*/,
      0 /*millisecond*/,
      0 /*microsecond*/,
    );
  }

  DateTime toTime() {
    return copyWith(year: 1970, month: 1, day: 1);
  }

  int toPronoteWeekNumber(PronoteSession session) {
    return 1 +
        ((toUtc().millisecondsSinceEpoch -
                    session.instance.firstMonday
                        .toUtc()
                        .millisecondsSinceEpoch) ~/
                (Duration.millisecondsPerSecond *
                    Duration.secondsPerMinute *
                    Duration.minutesPerHour *
                    Duration.hoursPerDay)) ~/
            7;
  }
}

extension AsTimings on int {
  ({int hour, int minute}) asTimings(PronoteSession session) =>
      session.instance.endings[this % session.instance.endings.length].timing;
}
