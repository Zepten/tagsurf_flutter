import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';

@dao
abstract class TagDao {
  @Insert()
  Future<void> insertTags(List<TagModel> tags);

  @Query('UPDATE tags SET name = :newName WHERE name = :oldName')
  Future<void> renameTag(String oldName, String newName);

  @Query('UPDATE tags SET color = :colorValue WHERE name = :tagName')
  Future<void> changeTagColor(String tagName, int colorValue);

  @Query('UPDATE tags SET parent_tag_name = :parentTagName WHERE name = :tagName')
  Future<void> setParentTag(String tagName, String parentTagName);

  @Query('UPDATE tags SET parent_tag_name = NULL WHERE name = :tagName')
  Future<void> removeParentTag(String tagName);

  @delete
  Future<void> deleteTag(TagModel tag);

  @Query('SELECT * FROM TAGS ORDER BY date_time_added ASC')
  Future<List<TagModel>> getAllTags();

  @Query('SELECT * FROM TAGS WHERE name = :tagName')
  Future<TagModel?> getTagByName(String tagName);

  @Query('SELECT * FROM TAGS WHERE name IN (:tagsNames)')
  Future<List<TagModel>> getTagsByNames(List<String> tagsNames);

  @Query('SELECT parent.* FROM tags AS child JOIN tags AS parent ON child.parent_tag_name = parent.name WHERE child.name = :tagName')
  Future<TagModel?> getParentByTagName(String tagName);
}
