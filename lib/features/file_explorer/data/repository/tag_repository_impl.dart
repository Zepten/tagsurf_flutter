import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/exceptions.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/general_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/tags_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final AppDatabase _appDatabase;

  TagRepositoryImpl(this._appDatabase);

  @override
  Future<Either<Failure, void>> createTag({required TagEntity tag}) async {
    try {
      final existingTag = await _appDatabase.tagDao.getTagByName(tag.name);
      if (existingTag == null) {
        await _appDatabase.tagDao.insertTag(TagModel.fromEntity(tag));
        return const Right(null);
      } else {
        return Left(TagDuplicateFailure(tag: tag.name));
      }
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createTags(
      {required List<TagEntity> tags}) async {
    try {
      final tagsNames = tags.map((tag) => tag.name).toList();
      final existingTags = await _appDatabase.tagDao.getTagsByNames(tagsNames);
      if (existingTags.isEmpty) {
        final tagsModels =
            tags.map((tagEntity) => TagModel.fromEntity(tagEntity)).toList();
        _appDatabase.tagDao.insertTags(tagsModels);
        return const Right(null);
      } else {
        final existingTagsNames = existingTags.map((tag) => tag.name).toList();
        return Left(TagsDuplicateFailure(tags: existingTagsNames));
      }
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateTag({required TagEntity tag}) async {
    try {
      final existingTag = await _appDatabase.tagDao.getTagByName(tag.name);
      if (existingTag != null && existingTag.name == tag.name) {
        await _appDatabase.tagDao.updateTag(TagModel.fromEntity(tag));
        return const Right(null);
      } else {
        return Left(TagNotExistsFailure(tag: tag.name));
      }
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTag({required TagEntity tag}) async {
    try {
      final existingTag = await _appDatabase.tagDao.getTagByName(tag.name);
      if (existingTag != null && existingTag.name == tag.name) {
        await _appDatabase.tagDao.deleteTag(TagModel.fromEntity(tag));
        return const Right(null);
      } else {
        return Left(TagNotExistsFailure(tag: tag.name));
      }
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<TagEntity>>> getAllTags() async {
    try {
      final tagsModels = await _appDatabase.tagDao.getAllTags();
      return Right(
          tagsModels.map((tagModel) => TagEntity.fromModel(tagModel)).toList());
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, TagEntity>> getTagByName(
      {required String name}) async {
    try {
      final tagModel = await _appDatabase.tagDao.getTagByName(name);
      if (tagModel != null) {
        return Right(TagEntity.fromModel(tagModel));
      } else {
        return Left(TagNotExistsFailure(tag: name));
      }
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<TagEntity>>> getTagsByNames(
      {required List<String> names}) async {
    try {
      final tagsModels = await _appDatabase.tagDao.getTagsByNames(names);
      if (tagsModels.isNotEmpty) {
        return Right(tagsModels
            .map((tagModel) => TagEntity.fromModel(tagModel))
            .toList());
      } else {
        return Left(TagsNotExistsFailure(tags: names));
      }
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<TagEntity>>> getParentTags(
      {required TagEntity childTag}) async {
    try {
      if (childTag.name == childTag.parentTagName) {
        return Left(InvalidTagFailure());
      } else if (childTag.parentTagName == null) {
        return Right(List.empty());
      } else {
        final tagsModels =
            await _appDatabase.tagDao.getParentTags(childTag.parentTagName!);
        return Right(tagsModels
            .map((tagModel) => TagEntity.fromModel(tagModel))
            .toList());
      }
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }
}
