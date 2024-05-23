import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/files_tags.dart';

@dao
abstract class FilesTagsDao {
  @Insert()
  Future<void> insertFileTags(FilesTagsModel filesTags);

  @Update()
  Future<void> updateFileTags(FilesTagsModel filesTags);

  @delete
  Future<void> deleteFileTags(FilesTagsModel filesTags);

  @Query('SELECT tag_id FROM files_tags WHERE file_path = :filePath')
  Future<List<int>> getTagsIdsByFilePath(String filePath);

  @Query('SELECT file_path FROM files_tags WHERE tag_id = :tagId')
  Future<List<String>> getFilesPathsByTag(int tagId);
}
