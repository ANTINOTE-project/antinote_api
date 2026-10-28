import 'dart:math';

final class const RemoteVersion.fromVersionNumbers({
  required final List<int> versionNumbers,
}) implements Comparable<RemoteVersion> {
  this
    : assert(
        versionNumbers.length >= 3,
        'At least 3 version numbers must be specified.',
      );

  int get year => versionNumbers[0];

  int get major => versionNumbers[1];

  int get minor => versionNumbers[2];

  int? get patch => versionNumbers.elementAtOrNull(3);

  factory RemoteVersion(int year, int major, int minor, [int? patch]) =>
      .fromVersionNumbers(versionNumbers: [year, major, minor, ?patch]);

  factory parse(String version) => .fromVersionNumbers(
    versionNumbers: version.split('.').map(int.parse).toList(growable: false),
  );

  @override
  int get hashCode => versionNumbers.hashCode;

  @override
  int compareTo(RemoteVersion other) {
    if (this == other) return 0;

    int searchLength = max(versionNumbers.length, other.versionNumbers.length);
    for (int i = 0; i < searchLength; i++) {
      final curNumber = versionNumbers.elementAtOrNull(i) ?? 0;
      final otherNumber = other.versionNumbers.elementAtOrNull(i) ?? 0;

      if (curNumber < otherNumber) return -1;
      if (curNumber > otherNumber) return 1;
    }

    return 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RemoteVersion && versionNumbers == other.versionNumbers);

  bool operator <(RemoteVersion other) => compareTo(other) < 0;

  bool operator <=(RemoteVersion other) => compareTo(other) <= 0;

  bool operator >(RemoteVersion other) => compareTo(other) > 0;

  bool operator >=(RemoteVersion other) => compareTo(other) >= 0;
}
