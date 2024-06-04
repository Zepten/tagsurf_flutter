import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

abstract class FileRepository {
  // File system methods for files
  Future<Either<Failure, List<FileEntity>>> getAllFilesFromDirectory({required String targetDir});
  Future<Either<Failure, void>> openFile({required FileEntity file});

  // Database methods for files
  Future<Either<Failure, List<FileEntity>>> getTrackedFiles({required String searchQuery});
  Future<Either<Failure, FileEntity>> getTrackedFileByPath({required String path});
  Future<Either<Failure, void>> trackFiles({required List<FileEntity> files});
  Future<Either<Failure, void>> updateFile({required FileEntity file});
  Future<Either<Failure, void>> untrackFile({required FileEntity file});
}
