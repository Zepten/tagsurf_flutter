import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';

class FileRepositoryImpl implements FileRepository {
  final FileSystemService _fileSystemService;
  final AppDatabase _appDatabase;

  FileRepositoryImpl(this._fileSystemService, this._appDatabase);

  // File system methods implementation for files
  @override
  Future<List<FileEntity>> getAllFilesFromDirectory(String targetDir) async {
    final filesModels =
        await _fileSystemService.getFilesFromDirectory(targetDir);
    return filesModels
        .map((fileModel) => FileEntity.fromModel(fileModel))
        .toList(growable: false);
  }

  // Database methods implementation for files
  @override
  Future<void> trackFile(FileEntity file) async {
    _appDatabase.fileDao.insertFile(FileModel.fromEntity(file));
  }

  @override
  Future<void> untrackFile(FileEntity file) async {
    _appDatabase.fileDao.deleteFile(FileModel.fromEntity(file));
  }

  @override
  Future<List<FileEntity>> getTrackedFiles() async {
    final filesModels = await _appDatabase.fileDao.getAllFiles();
    return filesModels
        .map((fileModel) => FileEntity.fromModel(fileModel))
        .toList(growable: false);
  }

  @override
  Future<FileEntity?> getTrackedFileByPath(String path) async {
    final fileModel = await _appDatabase.fileDao.getFileByPath(path);
    return fileModel == null ? null : FileEntity.fromModel(fileModel);
  }

  @override
  Future<List<FileEntity>> getUntrackedFilesFromDirectory(
      String targetDir) async {
    final filesModelsFromFs =
        await _fileSystemService.getFilesFromDirectory(targetDir);
    final filesModelsFromDb = await _appDatabase.fileDao.getAllFiles();
    return filesModelsFromFs
        .where((fileModel) => !filesModelsFromDb.contains(fileModel))
        .map((fileModel) => FileEntity.fromModel(fileModel))
        .toList(growable: false);
  }
}
