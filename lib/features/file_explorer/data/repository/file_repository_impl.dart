import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/exceptions.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
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
    } on FileSystemException {
      return Left(FileSystemFailure());
    }
  }

  // Database methods implementation for files
  @override
  Future<Either<Failure, void>> trackFile({required FileEntity file}) async {
    try {
      if (await _fileSystemService.isFileExist(FileModel.fromEntity(file))) {
        await _appDatabase.fileDao.insertFile(FileModel.fromEntity(file));
        return const Right(null);
      } else {
        return Left(FilesNotFoundFailure(paths: [file.path]));
      }
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> trackFiles(
      {required List<FileEntity> files}) async {
    try {
      final filesModels =
          files.map((fileEntity) => FileModel.fromEntity(fileEntity)).toList();
      final notExistFilesPaths =
          await _fileSystemService.getNotExistFilesPaths(filesModels);
      if (notExistFilesPaths.isEmpty) {
        await _appDatabase.fileDao.insertFiles(filesModels);
        return const Right(null);
      } else {
        return Left(FilesNotFoundFailure(paths: notExistFilesPaths));
      }
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> untrackFile({required FileEntity file}) async {
    try {
      await _appDatabase.fileDao.deleteFile(FileModel.fromEntity(file));
      return const Right(null);
    } on DatabaseException {
      return Left(DatabaseFailure());
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
        return Left(FilesNotFoundFailure(paths: notExistFilesPaths));
      }
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, FileEntity>> getTrackedFileByPath(
      {required String path}) async {
    // TODO: better error handling
    try {
      final fileModel = await _appDatabase.fileDao.getFileByPath(path);
      if (fileModel != null) {
        return Right(FileEntity.fromModel(fileModel));
      } else {
        return Left(DatabaseFailure());
      }
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<FileEntity>>> getUntrackedFilesFromDirectory(
      {required String targetDir}) async {
    // TODO: better error handling
    try {
      final filesModelsFromFs =
          await _fileSystemService.getFilesFromDirectory(targetDir);
      final filesModelsFromDb = await _appDatabase.fileDao.getAllFiles();
      return Right(filesModelsFromFs
          .where((fileModel) => !filesModelsFromDb.contains(fileModel))
          .map((fileModel) => FileEntity.fromModel(fileModel))
          .toList());
    } on FileSystemException {
      return Left(FileSystemFailure());
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }
}
