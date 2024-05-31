import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

abstract class FileRepository {
  // File system methods for files
  Future<Either<Failure, List<FileEntity>>> getAllFilesFromDirectory({required String targetDir});

  // Database methods for files
  Future<Either<Failure, List<FileEntity>>> getTrackedFiles();
  Future<Either<Failure, FileEntity>> getTrackedFileByPath({required String path});
  Future<Either<Failure, void>> trackFiles({required List<FileEntity> files});
  Future<Either<Failure, void>> updateFile({required FileEntity file});
  Future<Either<Failure, void>> untrackFile({required FileEntity file});
}
