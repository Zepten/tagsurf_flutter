import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/files_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';

@dao
abstract class FilesTagsDao {
  @Insert()
  Future<void> insertFileTags(FilesTagsModel filesTags);

  @delete
  Future<void> deleteFileTags(FilesTagsModel filesTags);

  @Query(
      'SELECT t.* FROM tags t JOIN files_tags ft ON t.name = ft.tag_name JOIN files f ON ft.file_path = f.path WHERE f.path = :filePath')
  Future<List<TagModel>> getTagsByFilePath(String filePath);

  @Query(
      'SELECT f.* FROM files f JOIN files_tags ft ON f.path = ft.file_path JOIN tags t ON ft.tag_name = t.name WHERE t.name = :tagName')
  Future<List<FileModel>> getFilesByTagName(String tagName);
}
