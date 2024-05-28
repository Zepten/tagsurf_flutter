import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

abstract class TagRepository {
  Future<Either<Failure,List<TagEntity>>> getAllTags();
  Future<Either<Failure,TagEntity?>> getTagByName({required String name});
  Future<Either<Failure,List<TagEntity>>> getParentTags({required TagEntity childTag});
  Future<Either<Failure,void>> createTag({required TagEntity tag});
  Future<Either<Failure,void>> createTags({required List<TagEntity> tags});
  Future<Either<Failure,void>> updateTag({required TagEntity tag});
  Future<Either<Failure,void>> deleteTag({required TagEntity tag});
}
