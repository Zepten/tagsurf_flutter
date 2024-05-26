import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';

class TagEntity extends Equatable {
  final String name;
  @ColumnInfo(name: 'parent_tag_name')
  final String? parentTagName;
  @ColumnInfo(name: 'color_code')
  final String colorCode;

  const TagEntity(
      {required this.name, this.parentTagName, required this.colorCode});

  factory TagEntity.fromModel(TagModel tagModel) {
    return TagEntity(
      name: tagModel.name,
      parentTagName: tagModel.parentTagName,
      colorCode: tagModel.colorCode,
    );
  }

  @override
  List<Object?> get props => [name, parentTagName, colorCode];
}
