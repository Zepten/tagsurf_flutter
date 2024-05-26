import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

@Entity(tableName: 'tags')
class TagModel extends Equatable {
  @PrimaryKey()
  final String name;
  @ColumnInfo(name: 'parent_tag_name')
  @ForeignKey(
      childColumns: ['parent_tag_name'],
      parentColumns: ['name'],
      entity: TagModel)
  final String? parentTagName;
  @ColumnInfo(name: 'color_code')
  final String colorCode;

  const TagModel(
      {required this.name, this.parentTagName, required this.colorCode});

  factory TagModel.fromEntity(TagEntity tagEntity) {
    return TagModel(
      name: tagEntity.name,
      parentTagName: tagEntity.parentTagName,
      colorCode: tagEntity.colorCode,
    );
  }

  @override
  List<Object?> get props => [name, parentTagName, colorCode];
}
