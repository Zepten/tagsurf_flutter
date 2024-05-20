import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/color_code_entity.dart';

@Entity(tableName: 'color_codes')
class ColorCodeModel extends ColorCodeEntity {
  const ColorCodeModel({required super.color});

  factory ColorCodeModel.fromEntity(ColorCodeEntity colorCodeEntity) {
    return ColorCodeModel(color: colorCodeEntity.color);
  }
}
