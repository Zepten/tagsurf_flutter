import 'dart:io';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';

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
    return _appDatabase.fileDao.getAllFiles();
  }

  @override
  Future<void> trackFile(FileEntity file) async {
    _appDatabase.fileDao.insertFile(FileModel.fromEntity(file));
  }

  @override
  Future<void> untrackFile(FileEntity file) async {
    _appDatabase.fileDao.deleteFile(FileModel.fromEntity(file));
  }
}