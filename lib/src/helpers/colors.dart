import 'dart:math';

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

const _channelScale = 0xFF;
const _hslDelphiMax = 240;

extension AsHSV on int {
  int rgbAsHSV() {
    final r = ((this & 0x00FF0000) >> 16) / _channelScale;
    final g = ((this & 0x0000FF00) >> 8) / _channelScale;
    final b = (this & 0x000000FF) / _channelScale;

    final v = max(max(r, g), b);
    final mMin = min(min(r, g), b);
    final diff = v - mMin;

    double h;
    double s;

    if (diff == 0) {
      h = 0;
      s = 0;
    } else {
      s = diff / v;

      double diffc(double c) => (v - c) / 6 / diff + 1 / 2;

      final rr = diffc(r);
      final gg = diffc(g);
      final bb = diffc(b);

      if (r == v) {
        h = bb - gg;
      } else if (g == v) {
        h = (1 / 3) + rr - bb;
      } else {
        // b == v
        h = (2 / 3) + gg - rr;
      }

      if (h < 0) {
        h += 1;
      } else if (h > 1) {
        h -= 1;
      }
    }

    final hPrime = (h * 255).round();
    final sPrime = (s * 255).round();
    final vPrime = (v * 255).round();

    return (this & 0xFF000000) | (hPrime << 16) | (sPrime << 8) | vPrime;
  }

  int hsvAsHSL() {
    final h_255 = (this & 0x00FF0000) >> 16;
    final s_255 = (this & 0x0000FF00) >> 8;
    final v_255 = (this & 0x000000FF);

    final double h_360 = h_255 * 360 / _channelScale;
    final double s_100 = s_255 * 100 / _channelScale;
    final double v_100 = v_255 * 100 / _channelScale;

    final double luminance = (200 - s_100) * v_100 / 200;

    double tempS;
    if (v_100 > 0) {
      final double denominator = (luminance < 50)
          ? (luminance * 2)
          : (200 - luminance * 2);

      if (denominator <= 0) {
        tempS = 0;
      } else {
        tempS = (s_100 * v_100) / denominator;
      }
    } else {
      tempS = 0;
    }

    final double finalH = h_360 * _hslDelphiMax / 360;
    final double finalL = luminance * _hslDelphiMax / 100;
    final double finalS = tempS * _hslDelphiMax / 100;

    final int newH = finalH.round().clamp(0, _hslDelphiMax);
    final int newS = finalS.round().clamp(0, _hslDelphiMax);
    final int newL = finalL.round().clamp(0, _hslDelphiMax);

    return (this & 0xFF000000) | (newH << 16) | (newS << 8) | newL;
  }

  int hslAsHSV() {
    final h_255 = (this & 0x00FF0000) >> 16;
    final s_255 = (this & 0x0000FF00) >> 8;
    final l_255 = (this & 0x000000FF);

    final double h_360 = h_255 * 360 / _hslDelphiMax;
    final double s_100 = s_255 * 100 / _hslDelphiMax;
    final double l_100 = l_255 * 100 / _hslDelphiMax;

    final double t = s_100 * (l_100 < 50 ? l_100 : 100 - l_100) / 100;

    double finalS100;
    if (l_100 > 0) {
      final double denominator = l_100 + t;
      if (denominator <= 0) {
        finalS100 = 0;
      } else {
        finalS100 = 200 * t / denominator;
      }
    } else {
      finalS100 = 0;
    }

    final double finalV100 = l_100 + t;

    final int hOut = (h_360 * _channelScale / 360).round().clamp(0, 255);
    final int sOut = (finalS100 * _channelScale / 100).round().clamp(0, 255);
    final int vOut = (finalV100 * _channelScale / 100).round().clamp(0, 255);

    return (this & 0xFF000000) | (hOut << 16) | (sOut << 8) | vOut;
  }

  int hsvAsRGB() {
    final h_255 = (this & 0x00FF0000) >> 16;
    final s_255 = (this & 0x0000FF00) >> 8;
    final v_255 = (this & 0x000000FF);

    if (s_255 == 0) {
      return (this & 0xFF000000) | (v_255 << 16) | (v_255 << 8) | v_255;
    }

    double h_360 = h_255 * 360 / 255;

    if (h_360 >= 360) {
      h_360 = 0;
    }

    final double t1 = v_255.toDouble();
    final double t2 = (255 - s_255) * v_255 / 255;
    final double t3 = (t1 - t2) * (h_360 % 60) / 60;

    double rDouble, gDouble, bDouble;

    final hueSector = h_360 ~/ 60;

    switch (hueSector) {
      case 0: // 0-59 degrees
        rDouble = t1;
        gDouble = t2 + t3;
        bDouble = t2;
        break;
      case 1: // 60-119 degrees
        rDouble = t1 - t3;
        gDouble = t1;
        bDouble = t2;
        break;
      case 2: // 120-179 degrees
        rDouble = t2;
        gDouble = t1;
        bDouble = t2 + t3;
        break;
      case 3: // 180-239 degrees
        rDouble = t2;
        gDouble = t1 - t3;
        bDouble = t1;
        break;
      case 4: // 240-299 degrees
        rDouble = t2 + t3;
        gDouble = t2;
        bDouble = t1;
        break;
      default: // 300-359 degrees
        rDouble = t1;
        gDouble = t2;
        bDouble = t1 - t3;
        break;
    }

    final int r = rDouble.round().clamp(0, 255);
    final int g = gDouble.round().clamp(0, 255);
    final int b = bDouble.round().clamp(0, 255);

    return (this & 0xFF000000) | (r << 16) | (g << 8) | b;
  }

  /// Input is RGB. Behavior is the same as remote's when [isLightTheme] is
  /// `true`. Behavior for when [isLightTheme] is `false` is custom.
  int classAccentToBackgroundColor({bool isLightTheme = true}) {
    var r = (this & 0x00FF0000) >> 16;
    var g = (this & 0x0000FF00) >> 8;
    var b = this & 0x000000FF;

    final hslValue = rgbAsHSV().hsvAsHSL();
    var h = (hslValue & 0x00FF0000) >> 16;
    var s = (hslValue & 0x0000FF00) >> 8;
    var l = hslValue & 0x000000FF;

    bool isCloseToGray = [
      r - g,
      r - b,
      g - b,
    ].every((combo) => combo.abs() < 10);
    if (!isCloseToGray) {
      isCloseToGray = s < 8;
    }

    if (isCloseToGray) {
      if (isLightTheme) {
        r = (r + 50).clamp(180, 255);
        g = (g + 50).clamp(180, 255);
        b = (b + 50).clamp(180, 255);
      } else {
        r = (r - 150).clamp(20, 45);
        g = (g - 150).clamp(20, 45);
        b = (b - 150).clamp(20, 45);
      }

      return (0xFF << 24) | (r << 16) | (g << 8) | b;
    }

    if (isLightTheme) {
      s = max(s - 100, 60);
      if (l < 140) {
        l = 160;
      } else if (l < 160) {
        l = 200;
      } else {
        l = 220;
      }
    } else {
      s = max(s - 80, 40);

      if (l > 180) {
        l = 45;
      } else if (l > 100) {
        l = 35;
      } else {
        l = 25;
      }
    }

    final hsl = (0xFF << 24) | (h << 16) | (s << 8) | l;

    return hsl.hslAsHSV().hsvAsRGB();
  }
}
