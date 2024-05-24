import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

abstract class TagRepository {
  Future<List<TagEntity>> getAllTags();
  Future<TagEntity?> getTagByName(String name);
  Future<List<TagEntity>> getParentTags(TagEntity childTag);
  Future<void> createTag(TagEntity tag);
  Future<void> updateTag(TagEntity tag);
  Future<void> deleteTag(TagEntity tag);
}
