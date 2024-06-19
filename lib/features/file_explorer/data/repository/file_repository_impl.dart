import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/exceptions.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/files_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/general_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/search_query_formatter.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/mapper/file_mapper.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';

class FileRepositoryImpl implements FileRepository {
  final FileSystemService fileSystemService;
  final AppDatabase appDatabase;

  FileRepositoryImpl(this.fileSystemService, this.appDatabase);

  // File system methods implementation for files
  @override
  Future<Either<Failure, List<FileEntity>>> getAllFilesFromDirectory(
      {required String targetDir}) async {
    try {
      final filesModels =
          await fileSystemService.getFilesFromDirectory(targetDir);
      return Right(FileMapper.toEntities(filesModels));
    } on FileSystemException catch (e) {
      return Left(FileSystemFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> openFile({required FileEntity file}) async {
    try {
      final fileModel = FileMapper.toModel(file);
      final isFileExist = await fileSystemService.isFileExist(fileModel);
      if (!isFileExist) {
        return Left(FilesNotInFileSystemFailure(files: [file.path]));
      }
      return Right(await fileSystemService.openFile(fileModel));
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
          await appDatabase.fileDao.getFilesByPaths(filesPaths);
      // Check if there are already existing files in DB
      if (existingFiles.isNotEmpty) {
        final existingFilesPaths =
            existingFiles.map((file) => file.path).toList();
        return Left(FilesDuplicateFailure(files: existingFilesPaths));
      }
      // Check if files are exist in file system
      final filesModels = FileMapper.toModels(files);
      try {
        final notInFsFilesPaths =
            await fileSystemService.getNotExistFilesPaths(filesModels);
        if (notInFsFilesPaths.isNotEmpty) {
          return Left(FilesNotInFileSystemFailure(files: notInFsFilesPaths));
        }
      } on FileSystemException catch (e) {
        return Left(FileSystemFailure(message: e.toString()));
      }
      // Track files
      await appDatabase.fileDao.insertFiles(filesModels);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> untrackFiles({required List<FileEntity> files}) async {
    try {
      final filesPaths = files.map((file) => file.path).toList();
      final existingFiles = await appDatabase.fileDao.getFilesByPaths(filesPaths);
      if (existingFiles.isNotEmpty) {
        await appDatabase.fileDao.deleteFiles(existingFiles);
      }
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
          await appDatabase.fileDao.getAllFiles(formattedSearchQuery);
      final notInFsFilesPaths =
          await fileSystemService.getNotExistFilesPaths(filesModels);
      // Check if files are exist in file system
      if (notInFsFilesPaths.isNotEmpty) {
        return Left(FilesNotInFileSystemFailure(files: notInFsFilesPaths));
      }
      return Right(FileMapper.toEntities(filesModels));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FileEntity>> getTrackedFileByPath(
      {required String path}) async {
    try {
      final fileModel = await appDatabase.fileDao.getFileByPath(path);
      if (fileModel == null) {
        return Left(FilesNotExistsFailure(files: [path]));
      }
      return Right(FileMapper.toEntity(fileModel));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
