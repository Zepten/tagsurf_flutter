import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';

@dao
abstract class FileDao {
  @Insert()
  Future<void> insertFiles(List<FileModel> files);

  @delete
  Future<void> deleteFiles(List<FileModel> files);

  @Query('SELECT * FROM FILES WHERE name LIKE :searchQuery ORDER BY date_time_added DESC')
  Future<List<FileModel>> getAllFiles(String searchQuery);

  @Query('SELECT * FROM FILES WHERE path = :path')
  Future<FileModel?> getFileByPath(String path);

  @Query('SELECT * FROM FILES WHERE path IN (:paths)')
  Future<List<FileModel>> getFilesByPaths(List<String> paths);
}
