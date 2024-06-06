import 'dart:ui';

import 'package:floor/floor.dart';

class ColorConverter implements TypeConverter<Color, int> {
  @override
  Color decode(int databaseValue) {
    return Color(databaseValue);
  }

  @override
  int encode(Color value) {
    return value.value;
  }
}