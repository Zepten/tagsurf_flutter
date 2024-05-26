import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

abstract class FileRepository {
  // File system methods for files
  Future<List<FileEntity>> getAllFilesFromDirectory({required String targetDir});

  // Database methods for files
  Future<List<FileEntity>> getTrackedFiles();
  Future<FileEntity?> getTrackedFileByPath({required String path});
  Future<List<FileEntity>> getUntrackedFilesFromDirectory({required String targetDir});
  Future<void> trackFile({required FileEntity file});
  Future<void> trackFiles({required List<FileEntity> files});
  Future<void> untrackFile({required FileEntity file});
}
