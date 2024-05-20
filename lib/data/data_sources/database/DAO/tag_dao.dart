import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/data/models/tag.dart';

@dao
abstract class TagDao {
  @Insert()
  Future<void> insertTag(TagModel tag);

  @delete
  Future<void> deleteTag(TagModel tag);

  @Query('select * from tags where id = :id')
  Future<TagModel?> findTagById(int id);

  @Query('select * from tags')
  Future<List<TagModel>> getAllTags();

  @Query('select name from tags')
  Future<List<String>> getAllTagsNames();
}
