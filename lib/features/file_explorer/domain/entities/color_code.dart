import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/config/constants/color_codes.dart';

class ColorCode extends Equatable {
  final int red;
  final int green;
  final int blue;

  const ColorCode({required this.red, required this.green, required this.blue});

  factory ColorCode.fromDefaults() {
    return ColorCode(
      red: defaultTagColor.red,
      green: defaultTagColor.green,
      blue: defaultTagColor.blue,
    );
  }

  @override
  List<Object?> get props => [red, green, blue];
}
