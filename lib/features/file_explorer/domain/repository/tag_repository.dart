import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/color_code.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

abstract class TagRepository {
  Future<Either<Failure, List<TagEntity>>> getAllTags();
  Future<Either<Failure, TagEntity>> getTagByName({required String name});
  Future<Either<Failure, List<TagEntity>>> getTagsByNames({required List<String> names});
  Future<Either<Failure, void>> createTag({required TagEntity tag});
  Future<Either<Failure, void>> renameTag({required TagEntity tag, required String newName});
  Future<Either<Failure, void>> changeTagColor({required TagEntity tag, required ColorCode color});
  Future<Either<Failure, void>> deleteTag({required TagEntity tag});
  Future<Either<Failure, void>> setParentTag({required TagEntity tag, required TagEntity? parentTag});
}
