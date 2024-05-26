import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

abstract class TagRepository {
  Future<List<TagEntity>> getAllTags();
  Future<TagEntity?> getTagByName({required String name});
  Future<List<TagEntity>> getParentTags({required TagEntity childTag});
  Future<void> createTag({required TagEntity tag});
  Future<void> createTags({required List<TagEntity> tags});
  Future<void> updateTag({required TagEntity tag});
  Future<void> deleteTag({required TagEntity tag});
}
