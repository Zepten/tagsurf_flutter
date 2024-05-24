import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

abstract class FileRepository {
  // File system methods for files
  Future<List<FileEntity>> getAllFilesFromDirectory(String targetDir);

  // Database methods for files
  Future<List<FileEntity>> getTrackedFiles();
  Future<FileEntity?> getTrackedFileByPath(String path);
  Future<List<FileEntity>> getUntrackedFilesFromDirectory(String targetDir);
  Future<void> trackFile(FileEntity file);
  Future<void> untrackFile(FileEntity file);
}
