import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/color_code.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

@Entity(tableName: 'tags', primaryKeys: [
  'name'
], foreignKeys: [
  ForeignKey(
      childColumns: ['parent_tag'], parentColumns: ['name'], entity: TagModel),
  ForeignKey(
      childColumns: ['color_code'],
      parentColumns: ['color'],
      entity: ColorCodeModel)
])
class TagModel extends TagEntity {
  const TagModel(
      {required super.name,
      required super.parentTag,
      required super.colorCode});

  factory TagModel.fromEntity(TagEntity tagEntity) {
    return TagModel(
      name: tagEntity.name,
      parentTag: tagEntity.parentTag!,
      colorCode: tagEntity.colorCode,
    );
  }
}
