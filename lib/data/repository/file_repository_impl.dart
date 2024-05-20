import 'dart:io';
import 'package:tagsurf_flutter/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/data/data_sources/file_system/file_system_service.dart';
import 'package:tagsurf_flutter/data/models/file.dart';
import 'package:tagsurf_flutter/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/domain/repository/file_repository.dart';

class FileRepositoryImpl implements FileRepository {
  final FileSystemService _fileSystemService;
  final AppDatabase _appDatabase;
  FileRepositoryImpl(this._fileSystemService, this._appDatabase);

  // File system methods implementation
  @override
  Future<List<File>> getFiles(Directory targetDir) {
    return _fileSystemService.getFiles(targetDir);
  }

  // Database methods implementation
  @override
  Future<List<FileModel>> getTrackedFiles() {
    return _appDatabase.fileDAO.getAllFiles();
  }

  @override
  Future<void> trackFile(FileEntity file) async {
    _appDatabase.fileDAO.insertFile(FileModel.fromEntity(file));
  }

  @override
  Future<void> untrackFile(FileEntity file) async {
    _appDatabase.fileDAO.deleteFile(FileModel.fromEntity(file));
  }
}
