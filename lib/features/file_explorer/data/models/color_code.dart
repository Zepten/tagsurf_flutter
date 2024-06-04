import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/color_code.dart';

class ColorCodeModel extends Equatable {
  final int red;
  final int green;
  final int blue;

  const ColorCodeModel({
    required this.red,
    required this.green,
    required this.blue,
  });

  factory ColorCodeModel.fromEntity(ColorCode colorCode) {
    return ColorCodeModel(
      red: colorCode.red.clamp(0, 255),
      green: colorCode.green.clamp(0, 255),
      blue: colorCode.blue.clamp(0, 255),
    );
  }

  @override
  List<Object?> get props => [red, green, blue];
}
