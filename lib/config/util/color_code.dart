import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/color_code.dart';

Color getColorFromColorCode(ColorCode colorCode) {
  return Color.fromARGB(255, colorCode.red, colorCode.green, colorCode.blue);
}

Color getLightShadeFromColorCode(ColorCode colorCode) {
  final color = getColorFromColorCode(colorCode);
  return Color.lerp(color, Colors.white, 0.75)!;
}

Color getContrastColorFromColorCode(ColorCode colorCode) {
  final color = getColorFromColorCode(colorCode);
  if (color == Colors.white || color == Colors.black) {
    return Colors.black;
  } else {
    return Color.lerp(color, Colors.black, 0.5)!;
  }
}
