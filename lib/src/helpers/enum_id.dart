abstract class EnumId implements Enum {
  final int id;

  EnumId(this.id);
}

/// Shamelessly stolen from Dart's EnumByName.
extension EnumById<T extends EnumId> on Iterable<T> {
  /// Shamelessly stolen from Dart's EnumByName.
  /// Functions like [EnumByName.byName] but by ID (for enums that implement
  /// [EnumId]).
  T byId(int id, {T? defaultValue}) {
    for (var value in this) {
      if (value.id == id) return value;
    }

    if (defaultValue != null) return defaultValue;

    throw ArgumentError.value(id, "id", "No enum value with that identifier");
  }
}
