import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

abstract class FileTagLinkRepository {
  Future<Either<Failure, List<FileEntity>>> getFilesByTags(
      {required List<TagEntity> tags});
  Future<Either<Failure, List<TagEntity>>> getTagsByFile(
      {required FileEntity file});
  Future<Either<Failure, List<FileEntity>>> getUntaggedFiles();
  Future<Either<Failure, void>> linkFileAndTag(
      {required String filePath, required String tagName});
  Future<Either<Failure, void>> linkOrCreateTag(
      {required String filePath, required String tagName});
  Future<Either<Failure, void>> unlinkFileAndTag(
      {required String filePath, required String tagName});
  // TODO: batch insert methods
}
