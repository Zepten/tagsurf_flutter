import 'package:flutter/material.dart';

class ColorUtil {
  static Color getLightShade(Color color) {
    return Color.lerp(color, Colors.white, 0.75)!;
  }

  static Color getDarkShade(Color color) {
    if (color == Colors.white) {
      return Colors.black;
    } else if (color == Colors.black) {
      return Colors.white;
    } else {
      return Color.lerp(color, Colors.black, 0.5)!;
    }
  }
}
