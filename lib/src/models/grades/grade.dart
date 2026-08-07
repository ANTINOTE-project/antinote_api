import 'dart:typed_data';

import 'package:antinote_api/src/helpers/enum_id.dart';
import 'package:antinote_api/src/helpers/visual_id.dart';

enum GradeType implements EnumId {
  error(-1),
  note(0),
  absent(1),
  exemption(2),
  notGraded(3),
  inapt(4),
  notHanded(5),
  absentZero(6),
  notHandedZero(7),
  felicitations(8);

  @override
  final int id;

  const GradeType(this.id);
}

final class const Grade({
  required final GradeType type,
  required final double value,
  required final String grade,
  required final double maxValue,
  required final String? rawContent,
}) {
  factory Grade.decodeString(String rawGrade, {int decimalPlaces = 2}) {
    final type = _gradeType(rawGrade);

    double value = _gradeValue(rawGrade);
    if ([GradeType.absentZero, GradeType.notHandedZero].contains(type)) {
      value = 0;
    }
    // TODO: Add handling stuff at line 6850 of eleve.js when data about grades is parsed.

    final grade = getGrade(value, decimalPlaces: decimalPlaces);

    return Grade(
      type: type,
      grade: grade,
      value: value,
      maxValue: 0,
      rawContent: rawGrade,
    );
  }

  factory Grade.decodeDouble(double rawGrade, {int decimalPlaces = 2}) {
    final grade = getGrade(rawGrade, decimalPlaces: decimalPlaces);

    return Grade(
      type: GradeType.note,
      grade: grade,
      value: rawGrade,
      maxValue: 0,
      rawContent: null,
    );
  }

  static const defaultUnknownGrade = Grade(
    type: .note,
    grade: '???',
    value: -1,
    maxValue: 0,
    rawContent: '???',
  );

  static final _commaRegex = RegExp(r'.0$');

  @override
  String toString() {
    if (value < 0) {
      return rawContent ?? grade;
    }
    return value.toString().replaceAll(_commaRegex, '').replaceAll('.', ',');
  }

  static GradeType _gradeType(String raw) {
    if (raw.split('|').length >= 2) {
      return GradeType.values.byId(int.parse(raw.split('|')[1]));
    }

    // TODO: Do some things with translation stuff at startup to better type this thing.
    return GradeType.note;
  }

  static double _gradeValue(String raw) {
    return double.tryParse(raw.replaceAll(',', '.')) ?? double.nan;
  }

  static String getGrade(double value, {int decimalPlaces = 2}) {
    if (value.isNaN) return '';
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  Uint8List visualIdData() {
    return Uint8List.fromList([
      type.id,
      ...grade.visualIdData(),
      ...value.toString().visualIdData(),
      ...maxValue.toString().visualIdData(),
      ...?rawContent?.visualIdData(),
    ]);
  }
}
