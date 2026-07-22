import 'package:antinote/src/helpers/crypto.dart';

extension AsColorCode on String {
  int asRGB() {
    String rawColor = this;
    if (rawColor.startsWith('#')) {
      rawColor = rawColor.substring(1);
    }

    final [int r, int g, int b] = rawColor.fromHex();

    return (0xFF << 24) | (r << 16) | (g << 8) | b;
  }
}
