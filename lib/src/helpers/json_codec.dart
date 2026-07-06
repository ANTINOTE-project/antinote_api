import 'dart:convert';

import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/models/date.dart';
import 'package:antinote/src/models/domain.dart';
import 'package:antinote/src/models/grades/grade.dart';

const _intSetType = -1;
const _resolvedJsonReferenceType = -2;

class RemoteJsonDecoder {
  final String data;
  List<JsonReference> references = [];

  RemoteJsonDecoder({required this.data});

  Map<String, dynamic> decode() {
    final result = JsonDecoder(revive).convert(data);

    return result as Map<String, dynamic>;
  }

  void resolveAll(MapJsonNavigator nav) {
    for (final reference in references) {
      reference.resolve(nav);
    }
  }

  Object? revive(Object? key, Object? value) {
    if (value is! Map<String, dynamic>) return value;

    if (value case {'_T': final type, 'V': final value}) {
      final dynamic parsedValue;

      switch (type) {
        case _intSetType:
          assert(value is List);
          parsedValue = (value as List).cast<int>().toSet();
        case _resolvedJsonReferenceType:
          assert(value is String);
          parsedValue = base64Decode(value);
        case 15:
        case 8:
          // It's a domain.
          assert(value is String);
          parsedValue = (value as String).asDomain();
        case 7:
          // That's a remote DateTime.
          assert(value is String);
          parsedValue = (value as String).asRemoteDate();
        case 10:
          // It's a grade.
          if (value is String) {
            parsedValue = Grade.decodeString(value);
          } else if (value is double) {
            parsedValue = Grade.decodeDouble(value);
          } else {
            throw UnimplementedError();
          }

        case 11:
          // It's a cardinal domain.
          assert(
            value is String,
          ); // If it isn't (and it is a number), you need to create a list of length n with the nth value being 1.
          parsedValue = (value as String).asDomain();
        case 14:
          assert(value is String);
          parsedValue = (value as String);
        case 21:
          // This is pre-cleaned HTML.
          assert(value is String);
          parsedValue = value;
        case 23:
          // That's just a String.
          assert(value is String);
          parsedValue = value;
        case 24:
          // This just replaces special characters to their HTML-usable variant,
          // since we do not use any HTML, no need to do it here.
          parsedValue = value;
        case 25:
          // This is a file. In this case, we put a reference to the file that's
          // upper and parse it later when we resolve it.
          final ref = JsonReference(
            rawReference: value,
            resolver: (nav) => base64Decode(
              nav
                  .getL<String>('fichiers')
                  .get(value)
                  .replaceAll(RegExp(r'[\r\n]'), ''),
            ),
            serializer: (resolved) => base64Encode(resolved),
          );
          references.add(ref);
          parsedValue = ref;
        case 26:
          // It's a set of ints.
          assert(value is String);
          parsedValue = (value as String).asDomain().toSet();
        case 27:
          // It's XSS-cleaned HTML, we keep it as String.
          assert(value is String);
          parsedValue = value;
        default:
          throw UnimplementedError('Unknown type: $type for value $value');
      }

      return parsedValue;
    }

    return value;
  }
}

// TODO: Make this WAY more useful...
class RemoteJsonEncoder {
  final Map<String, dynamic> data;

  RemoteJsonEncoder({required this.data});

  String encode() => JsonEncoder(toEncodable).convert(data);

  dynamic toEncodable(dynamic value) {
    if (value is Set<int>) {
      return {'_T': _intSetType, 'V': value.toList(growable: false)};
    } else if (value is DateTime) {
      return {'_T': 7, 'V': value.asRemoteDate()};
    } else if (value is Grade) {
      return {'_T': 10, 'V': value.rawContent ?? value.value};
    } else if (value is JsonReference) {
      return {'_T': _resolvedJsonReferenceType, 'V': value.serialize()};
    } else {
      throw UnimplementedError(
        "Don't know how to serialize $value of type ${value.runtimeType}",
      );
    }
  }
}
