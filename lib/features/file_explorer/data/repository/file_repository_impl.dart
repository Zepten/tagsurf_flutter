import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/exceptions.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/files_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/general_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/search_query_formatter.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';

class FileRepositoryImpl implements FileRepository {
  final FileSystemService _fileSystemService;
  final AppDatabase _appDatabase;

  FileRepositoryImpl(this._fileSystemService, this._appDatabase);

  // Map file models to file entities
  List<FileEntity> _toFilesEntities(List<FileModel> filesModels) {
    return filesModels
        .map((fileModel) => FileEntity.fromModel(fileModel))
        .toList();
  }

  // Map file entities to file models
  List<FileModel> _toFilesModels(List<FileEntity> filesEntities) {
    return filesEntities
        .map((fileEntity) => FileModel.fromEntity(fileEntity))
        .toList();
  }

  // File system methods implementation for files
  @override
  Future<Either<Failure, List<FileEntity>>> getAllFilesFromDirectory(
      {required String targetDir}) async {
    try {
      final filesModels =
          await _fileSystemService.getFilesFromDirectory(targetDir);
      return Right(_toFilesEntities(filesModels));
    } on FileSystemException catch (e) {
      return Left(FileSystemFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> openFile({required FileEntity file}) async {
    try {
      final fileModel = FileModel.fromEntity(file);
      final isFileExist = await _fileSystemService.isFileExist(fileModel);
      if (!isFileExist) {
        return Left(FilesNotInFileSystemFailure(files: [file.path]));
      }
      return Right(await _fileSystemService.openFile(fileModel));
    } on FileSystemException catch (e) {
      return Left(FileSystemFailure(message: e.toString()));
    }
  }

  // Database methods implementation for files
  @override
  Future<Either<Failure, void>> trackFiles(
      {required List<FileEntity> files}) async {
    try {
      final filesPaths = files.map((file) => file.path).toList();
      final existingFiles =
          await _appDatabase.fileDao.getFilesByPaths(filesPaths);
      // Check if there are already existing files in DB
      if (existingFiles.isNotEmpty) {
        final existingFilesPaths =
            existingFiles.map((file) => file.path).toList();
        return Left(FilesDuplicateFailure(files: existingFilesPaths));
      }
      // Check if files are exist in file system
      final filesModels = _toFilesModels(files);
      try {
        final notInFsFilesPaths =
            await _fileSystemService.getNotExistFilesPaths(filesModels);
        if (notInFsFilesPaths.isNotEmpty) {
          return Left(FilesNotInFileSystemFailure(files: notInFsFilesPaths));
        }
      } on FileSystemException catch (e) {
        return Left(FileSystemFailure(message: e.toString()));
      }
      // Track files
      await _appDatabase.fileDao.insertFiles(filesModels);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateFile({required FileEntity file}) async {
    try {
      final existingFile = await _appDatabase.fileDao.getFileByPath(file.path);
      // Check if file exists in DB
      if (existingFile == null) {
        return Left(FilesNotExistsFailure(files: [file.path]));
      }
      // Check if file is exists in file system
      if (!await _fileSystemService.isFileExist(FileModel.fromEntity(file))) {
        return Left(FilesNotInFileSystemFailure(files: [file.path]));
      }
      await _appDatabase.fileDao.updateFile(FileModel.fromEntity(file));
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> untrackFile({required FileEntity file}) async {
    try {
      final existingFile = await _appDatabase.fileDao.getFileByPath(file.path);
      if (existingFile != null) {
        await _appDatabase.fileDao.deleteFile(existingFile);
      }
      await _appDatabase.fileDao.deleteFile(FileModel.fromEntity(file));
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FileEntity>>> getTrackedFiles(
      {required String searchQuery}) async {
    try {
      final formattedSearchQuery =
          SearchQueryFormatter.formatForSql(searchQuery);
      final filesModels =
          await _appDatabase.fileDao.getAllFiles(formattedSearchQuery);
      final notInFsFilesPaths =
          await _fileSystemService.getNotExistFilesPaths(filesModels);
      // Check if files are exist in file system
      if (notInFsFilesPaths.isNotEmpty) {
        return Left(FilesNotInFileSystemFailure(files: notInFsFilesPaths));
      }
      return Right(_toFilesEntities(filesModels));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FileEntity>> getTrackedFileByPath(
      {required String path}) async {
    try {
      final fileModel = await _appDatabase.fileDao.getFileByPath(path);
      if (fileModel == null) {
        return Left(FilesNotExistsFailure(files: [path]));
      }
      return Right(FileEntity.fromModel(fileModel));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
