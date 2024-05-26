import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/color_code.dart';

class TagEntity extends Equatable {
  final String name;
  final String? parentTagName;
  final ColorCode colorCode;

  const TagEntity(
      {required this.name, this.parentTagName, required this.colorCode});

  factory TagEntity.fromModel(TagModel tagModel) {
    return TagEntity(
      name: tagModel.name,
      parentTagName: tagModel.parentTagName,
      colorCode: ColorCode(
          red: tagModel.colorCodeRed,
          green: tagModel.colorCodeGreen,
          blue: tagModel.colorCodeBlue),
    );
  }

  @override
  List<Object?> get props => [name, parentTagName, colorCode];
}
