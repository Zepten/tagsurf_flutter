import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/color_code.dart';

class TagEntity extends Equatable {
  final String name;
  final String? parentTagName;
  final ColorCode colorCode;
  final DateTime dateTimeAdded;

  const TagEntity({
    required this.name,
    this.parentTagName,
    required this.colorCode,
    required this.dateTimeAdded,
  });

  factory TagEntity.fromModel(TagModel tagModel) {
    return TagEntity(
      name: tagModel.name,
      parentTagName: tagModel.parentTagName,
      colorCode: ColorCode(
          red: tagModel.colorCodeRed,
          green: tagModel.colorCodeGreen,
          blue: tagModel.colorCodeBlue),
      dateTimeAdded: tagModel.dateTimeAdded,
    );
  }

  factory TagEntity.fromDefaults(String name) {
    return TagEntity(
      name: name,
      colorCode: ColorCode.fromDefaults(),
      dateTimeAdded: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [name, parentTagName, colorCode, dateTimeAdded];
}
