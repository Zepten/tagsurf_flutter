import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/color_code_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

@Entity(tableName: 'tags', foreignKeys: [
  ForeignKey(
      childColumns: ['parent_tag_id'],
      parentColumns: ['id'],
      entity: TagEntity),
  ForeignKey(
      childColumns: ['color_code'],
      parentColumns: ['color'],
      entity: ColorCodeEntity)
])
class TagModel extends TagEntity {
  const TagModel(
      {required super.id,
      required super.name,
      required super.parentTag,
      required super.colorCode});

  factory TagModel.fromEntity(TagEntity tagEntity) {
    return TagModel(
      id: tagEntity.id,
      name: tagEntity.name,
      parentTag: tagEntity.parentTag,
      colorCode: tagEntity.colorCode,
    );
  }
}
