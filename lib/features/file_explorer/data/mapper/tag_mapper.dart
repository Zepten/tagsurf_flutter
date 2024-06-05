import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

class TagMapper {
  static TagModel toModel(TagEntity tagEntity) {
    return TagModel(
      name: tagEntity.name,
      parentTagName: tagEntity.parentTagName,
      color: tagEntity.color,
      dateTimeAdded: tagEntity.dateTimeAdded,
    );
  }

  static TagEntity toEntity(TagModel tagModel) {
    return TagEntity(
      name: tagModel.name,
      parentTagName: tagModel.parentTagName,
      color: tagModel.color,
      dateTimeAdded: tagModel.dateTimeAdded,
    );
  }

  static List<TagModel> toModels(List<TagEntity> tagsEntities) {
    return tagsEntities
        .map((tagEntity) => TagMapper.toModel(tagEntity))
        .toList();
  }

  static List<TagEntity> toEntities(List<TagModel> tagsModels) {
    return tagsModels
        .map((tagModel) => TagMapper.toEntity(tagModel))
        .toList();
  }
}