import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/domain/entities/tag_entity.dart';

@Entity(tableName: 'tags', primaryKeys: ['id'])
class TagModel extends TagEntity {
  const TagModel(
      {required super.id,
      required super.name,
      required super.colorCode,
      required super.parentTag});

  factory TagModel.fromEntity(TagEntity tagEntity) {
    return TagModel(
      id: tagEntity.id,
      name: tagEntity.name,
      colorCode: tagEntity.colorCode,
      parentTag: tagEntity.parentTag,
    );
  }
}
