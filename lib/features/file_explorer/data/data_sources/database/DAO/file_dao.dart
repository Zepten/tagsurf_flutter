import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';

@dao
abstract class FileDao {
  @Insert()
  Future<void> insertFile(FileModel file);

  @delete
  Future<void> deleteFile(FileModel file);

  @Query('select * from files')
  Future<List<FileModel>> getAllFiles();
}
