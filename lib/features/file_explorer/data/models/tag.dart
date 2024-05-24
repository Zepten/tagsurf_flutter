import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

@Entity(tableName: 'tags', primaryKeys: [
  'name'
], foreignKeys: [
  ForeignKey(
      childColumns: ['parent_tag_name'], parentColumns: ['name'], entity: TagModel)
])
class TagModel extends TagEntity {
  const TagModel(
      {required super.name,
      required super.parentTagName,
      required super.colorCode});

  factory TagModel.fromEntity(TagEntity tagEntity) {
    return TagModel(
      name: tagEntity.name,
      parentTagName: tagEntity.parentTagName,
      colorCode: tagEntity.colorCode,
    );
  }
}
