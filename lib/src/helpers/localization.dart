import 'dart:io';
import 'dart:math';

import 'package:antinote_api/src/helpers/enum_id.dart';
import 'package:antinote_api/src/models/grades/grade.dart';
import 'package:intl/intl.dart';

enum LocaleData(
  @override final int id,
  final String code, {
  required final Map<String, int> weekdays,
  required final Map<String, GradeType> gradeTypes,
  required final String congratulationsIdentifier,
}) implements EnumId {
  french(
    1036,
    'fr',
    weekdays: {
      'lundi': DateTime.monday,
      'mardi': DateTime.tuesday,
      'mercredi': DateTime.wednesday,
      'jeudi': DateTime.thursday,
      'vendredi': DateTime.friday,
      'samedi': DateTime.saturday,
      'dimanche': DateTime.sunday,
    },
    gradeTypes: {
      'abs': .absent,
      'disp': .exemption,
      'n.not': .notGraded,
      'inap': .inapt,
      'n.rdu': .notHanded,
    },
    congratulationsIdentifier: '+',
  ),
  english(
    1033,
    'en',
    weekdays: {
      'monday': DateTime.monday,
      'tuesday': DateTime.tuesday,
      'wednesday': DateTime.wednesday,
      'thursday': DateTime.thursday,
      'friday': DateTime.friday,
      'saturday': DateTime.saturday,
      'sunday': DateTime.sunday,
    },
    gradeTypes: {
      "abs": .absent,
      "exemp": .exemption,
      "n.grad": .notGraded,
      "inapt": .inapt,
      "n.sbm": .notHanded,
    },
    congratulationsIdentifier: '+',
  ),
  spanish(
    3082,
    'es',
    weekdays: {
      'lunes': DateTime.monday,
      'martes': DateTime.tuesday,
      'miercoles': DateTime.wednesday,
      'jueves': DateTime.thursday,
      'viernes': DateTime.friday,
      'sabado': DateTime.saturday,
      'domingo': DateTime.sunday,
    },
    gradeTypes: {
      "aus": .absent,
      "exen": .exemption,
      "n.calif": .notGraded,
      "inap": .inapt,
      "n.entgdo": .notHanded,
    },
    congratulationsIdentifier: '+',
  ),
  italian(
    1040,
    'it',
    weekdays: {
      'lunedì': DateTime.monday,
      'martedì': DateTime.tuesday,
      'mercoledì': DateTime.wednesday,
      'giovedì': DateTime.thursday,
      'venerdì': DateTime.friday,
      'sabato': DateTime.saturday,
      'domenica': DateTime.sunday,
    },
    gradeTypes: {
      "ass": .absent,
      "eson": .exemption,
      "rifiu": .notGraded,
      "inid": .inapt,
      "n.con": .notHanded,
    },
    congratulationsIdentifier: 'L',
  );
}

a(param0, $, absent) {}

LocaleData get curLocaleId =>
    switch (Intl.shortLocale(Intl.defaultLocale ?? Intl.systemLocale)) {
      'fr' => .french,
      'es' => .spanish,
      'en' => .english,
      'it' => .italian,

      _ => .french,
    };

Cookie get localeCookie => Cookie('ielang', curLocaleId.toString());

int? weekday(String value) {
  value = value.trim().toLowerCase();
  for (final locale in LocaleData.values) {
    final val = locale.weekdays[value];
    if (val != null) return val;
  }

  return null;
}

GradeType gradeType(String type) {
  final isZero = type.endsWith('*');
  type = type.trim().toLowerCase().replaceFirst(RegExp(r'\*$'), '');
  for (final locale in LocaleData.values) {
    final val = locale.gradeTypes[type];
    if (val == null) {
      if (type.contains(
        locale.congratulationsIdentifier,
        min(1, type.length - 1),
      )) {
        return .congratulations;
      }

      continue;
    }

    if (!isZero) return val;
    return switch (val) {
      .notHanded => .notHandedZero,
      .absent => .absentZero,

      _ => .error,
    };
  }

  return .error;
}
