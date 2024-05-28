import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';

@dao
abstract class TagDao {
  @Insert()
  Future<void> insertTag(TagModel tag);

  @Insert()
  Future<void> insertTags(List<TagModel> tags);

  @Update()
  Future<void> updateTag(TagModel tag);

  @delete
  Future<void> deleteTag(TagModel tag);

  @Query('select * from tags')
  Future<List<TagModel>> getAllTags();

  @Query('select * from tags where name = :name')
  Future<TagModel?> getTagByName(String name);

  @Query('select * from tags where name in (:names)')
  Future<List<TagModel>> getTagsByNames(List<String> names);

  @Query('select * from tags where name = :parentTagName')
  Future<List<TagModel>> getParentTags(String parentTagName);
}
