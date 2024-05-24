import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/color_code.dart';

class ColorCodeEntity extends Equatable {
  final String? color;

  const ColorCodeEntity({required this.color});

  factory ColorCodeEntity.fromModel(ColorCodeModel colorCodeModel) {
    return ColorCodeEntity(color: colorCodeModel.color);
  }

  @override
  List<Object?> get props => [color];
}
