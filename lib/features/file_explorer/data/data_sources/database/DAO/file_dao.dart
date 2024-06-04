import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';

@dao
abstract class FileDao {
  @Insert()
  Future<void> insertFile(FileModel file);

  @Insert()
  Future<void> insertFiles(List<FileModel> files);

  @Update()
  Future<void> updateFile(FileModel file);

  @delete
  Future<void> deleteFile(FileModel file);

  @Query('SELECT * FROM FILES WHERE name LIKE :searchQuery ORDER BY date_time_added DESC')
  Future<List<FileModel>> getAllFiles(String searchQuery);

  @Query('SELECT * FROM FILES WHERE path = :path')
  Future<FileModel?> getFileByPath(String path);

  @Query('SELECT * FROM FILES WHERE path IN (:paths)')
  Future<List<FileModel>> getFilesByPaths(List<String> paths);
}
