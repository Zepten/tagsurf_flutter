import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file_tags.dart';

@dao
abstract class FileTagsDao {
  @Insert()
  Future<void> insertFileTags(FileTagsModel fileTags);

  @Update()
  Future<void> updateFileTags(FileTagsModel fileTags);

  @delete
  Future<void> deleteFileTags(FileTagsModel fileTags);
}