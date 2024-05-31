import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/exceptions.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/files_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/general_failures.dart';
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
  Future<Either<Failure, List<FileEntity>>> getAllFilesFromDirectory(
      {required String targetDir}) async {
    try {
      final filesModels =
          await _fileSystemService.getFilesFromDirectory(targetDir);
      return Right(filesModels
          .map((fileModel) => FileEntity.fromModel(fileModel))
          .toList());
    } on FileSystemException catch (e) {
      return Left(FileSystemFailure(message: e.toString()));
    }
  }

  // Database methods implementation for files
  @override
  Future<Either<Failure, void>> trackFile({required FileEntity file}) async {
    try {
      final existingFile = await _appDatabase.fileDao.getFileByPath(file.path);
      if (existingFile != null) {
        return Left(FilesDuplicateFailure(files: [file.path]));
      } else if (await _fileSystemService
          .isFileExist(FileModel.fromEntity(file))) {
        await _appDatabase.fileDao.insertFile(FileModel.fromEntity(file));
        return const Right(null);
      } else {
        return Left(FilesNotInFileSystemFailure(files: [file.path]));
      }
    } on DatabaseException catch(e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateFile({required FileEntity file}) async {
    try {
      final existingFile = await _appDatabase.fileDao.getFileByPath(file.path);
      if (existingFile == null) {
        return Left(FilesNotExistsFailure(files: [file.path]));
      } else if (await _fileSystemService
          .isFileExist(FileModel.fromEntity(file))) {
        await _appDatabase.fileDao.updateFile(FileModel.fromEntity(file));
        return const Right(null);
      } else {
        return Left(FilesNotInFileSystemFailure(files: [file.path]));
      }
    } on DatabaseException catch(e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> trackFiles(
      {required List<FileEntity> files}) async {
    try {
      final filesPaths = files.map((file) => file.path).toList();
      final existingFiles =
          await _appDatabase.fileDao.getFilesByPaths(filesPaths);
      if (existingFiles.isNotEmpty) {
        final existingFilesPaths =
            existingFiles.map((file) => file.path).toList();
        return Left(FilesDuplicateFailure(files: existingFilesPaths));
      } else {
        final filesModels = files
            .map((fileEntity) => FileModel.fromEntity(fileEntity))
            .toList();
        final notInFsFilesPaths =
            await _fileSystemService.getNotExistFilesPaths(filesModels);
        if (notInFsFilesPaths.isEmpty) {
          await _appDatabase.fileDao.insertFiles(filesModels);
          return const Right(null);
        } else {
          return Left(FilesNotInFileSystemFailure(files: notInFsFilesPaths));
        }
      }
    } on DatabaseException catch(e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> untrackFile({required FileEntity file}) async {
    try {
      final existingFile = await _appDatabase.fileDao.getFileByPath(file.path);
      if (existingFile == null) {
        return Left(FilesNotExistsFailure(files: [file.path]));
      } else {
        await _appDatabase.fileDao.deleteFile(FileModel.fromEntity(file));
        return const Right(null);
      }
    } on DatabaseException catch(e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FileEntity>>> getTrackedFiles() async {
    try {
      final filesModels = await _appDatabase.fileDao.getAllFiles();
      final notExistFilesPaths =
          await _fileSystemService.getNotExistFilesPaths(filesModels);
      if (notExistFilesPaths.isEmpty) {
        return Right(filesModels
            .map((fileModel) => FileEntity.fromModel(fileModel))
            .toList());
      } else {
        return Left(FilesNotInFileSystemFailure(files: notExistFilesPaths));
      }
    } on DatabaseException catch(e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FileEntity>> getTrackedFileByPath(
      {required String path}) async {
    try {
      final fileModel = await _appDatabase.fileDao.getFileByPath(path);
      if (fileModel != null) {
        return Right(FileEntity.fromModel(fileModel));
      } else {
        return Left(FilesNotExistsFailure(files: [path]));
      }
    } on DatabaseException catch(e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FileEntity>>> getTrackedFilesByPaths(
      {required List<String> paths}) async {
    try {
      final filesModels = await _appDatabase.fileDao.getFilesByPaths(paths);
      if (filesModels.isNotEmpty) {
        return Right(filesModels
            .map((fileModel) => FileEntity.fromModel(fileModel))
            .toList());
      } else {
        return Left(FilesNotExistsFailure(files: paths));
      }
    } on DatabaseException catch(e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
