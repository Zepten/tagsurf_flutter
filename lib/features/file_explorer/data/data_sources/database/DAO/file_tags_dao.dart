import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file_tags.dart';

@dao
abstract class FileTagsDao {
  @Insert()
  Future<void> insertFileTags(FileTagsModel filesTags);

  @Update()
  Future<void> updateFileTags(FileTagsModel filesTags);

  @delete
  Future<void> deleteFileTags(FileTagsModel filesTags);
}
