import 'dart:typed_data';

import 'package:antinote_api/src/helpers/enum_id.dart';
import 'package:antinote_api/src/helpers/localization.dart';
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
  congratulations(8);

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
    // TODO: The congratulations are disabled behind a flag that's probably in
    // TODO: the instance parameters, we need to check it.
    final type = _gradeType(rawGrade);

    double value = _gradeValue(rawGrade);
    if ([GradeType.absentZero, GradeType.notHandedZero].contains(type)) {
      value = 0;
    }

    final grade = getGrade(value, decimalPlaces: decimalPlaces);

    return Grade(
      type: type,
      grade: grade,
      value: value,
      maxValue: _gradeMax(rawGrade),
      rawContent: rawGrade,
    );
  }

  factory Grade.decodeDouble(double rawGrade, {int decimalPlaces = 2}) {
    final grade = getGrade(rawGrade, decimalPlaces: decimalPlaces);

    return Grade(
      type: .note,
      grade: grade,
      value: rawGrade,
      maxValue: 0,
      rawContent: rawGrade.toString(),
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

    return gradeType(raw);
  }

  static double _gradeValue(String raw) {
    return double.tryParse(
          cleanRawGrade(raw.split('|').first.replaceAll(',', '.')),
        ) ??
        double.nan;
  }

  static double _gradeMax(String raw) {
    final max = raw.split('|').elementAtOrNull(2);
    if (max == null) return 0;

    return double.tryParse(cleanRawGrade(max.replaceAll(',', '.'))) ??
        double.nan;
  }

  static String getGrade(double value, {int decimalPlaces = 2}) {
    if (value.isNaN) return '';
    return value.toStringAsFixed(decimalPlaces).replaceAll('.', ',');
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
