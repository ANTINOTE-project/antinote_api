import 'package:antinote/src/helpers/json.dart';

extension FromRemoteDate on String {
  DateTime asRemoteDate() {
    final shortDateRe = RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$');
    final longDateLongHoursRe = RegExp(
      r'^\d{1,2}/\d{1,2}/\d{4} \d{1,2}:\d{1,2}:\d{1,2}$',
    );
    final longDateShortHoursRe = RegExp(
      r'^\d{1,2}/\d{1,2}/\d{2} \d{1,2}h\d{1,2}$',
    );
    final yearFirstTwoChars = DateTime.now().year ~/ 100 * 100;

    if (shortDateRe.hasMatch(this)) {
      final [day, month, year] = split('/').mapL(int.parse);

      return DateTime.utc(year, month, day);
    } else if (longDateLongHoursRe.hasMatch(this)) {
      final [date, time] = split(' ');
      final [day, month, year] = date.split('/').mapL(int.parse);

      final [hours, minutes, seconds] = time.split(':').mapL(int.parse);

      return DateTime.utc(year, month, day, hours, minutes, seconds);
    } else if (longDateShortHoursRe.hasMatch(this)) {
      final [date, time] = split(' ');
      final [day, month, year] = date.split('/').mapL(int.parse);

      final [hours, minutes] = time.split('h').mapL(int.parse);

      return DateTime.utc(yearFirstTwoChars + year, month, day, hours, minutes);
    } else {
      throw UnimplementedError(this);
    }
  }
}

extension ToRemoteDate on DateTime {
  String asRemoteDate() {
    return '$day/$month/$year $hour:$minute:$second';
  }
}
