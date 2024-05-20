import 'dart:io';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

abstract class FileRepository {
  // TODO: File system methods
  Future<List<File>> getFiles(Directory targetDir);

  // TODO: Database methods
  Future<List<FileEntity>> getTrackedFiles();
  Future<void> trackFile(FileEntity file);
  Future<void> untrackFile(FileEntity file);
}
