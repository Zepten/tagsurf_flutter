import 'dart:ui';

import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/exceptions.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/general_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/tags_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/mapper/tag_mapper.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final AppDatabase appDatabase;

  TagRepositoryImpl(this.appDatabase);

  Future<bool> _isCyclicDependency(
      String tagName, String? parentTagName) async {
    if (parentTagName == null) {
      return false;
    } else if (parentTagName == tagName) {
      return true;
    }
    TagModel? currentTag =
        await appDatabase.tagDao.getParentByTagName(parentTagName);
    while (currentTag != null) {
      if (currentTag.name == tagName) {
        return true;
      }
      currentTag = currentTag.parentTagName != null
          ? await appDatabase.tagDao.getParentByTagName(currentTag.name)
          : null;
    }
    return false;
  }

  @override
  Future<Either<Failure, void>> createTag({required TagEntity tag}) async {
    try {
      final existingTag = await appDatabase.tagDao.getTagByName(tag.name);
      if (existingTag == null) {
        final isCyclicDependency =
            await _isCyclicDependency(tag.name, tag.parentTagName);
        if (isCyclicDependency) {
          return Left(TagsCyclicDependencyFailure(tags: [tag]));
        }
        await appDatabase.tagDao.insertTag(TagMapper.toModel(tag));
        return const Right(null);
      } else {
        return Left(TagsDuplicateFailure(tags: [tag.name]));
      }
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> renameTag({
    required TagEntity tag,
    required String newName,
  }) async {
    try {
      final existingTag = await appDatabase.tagDao.getTagByName(tag.name);
      if (existingTag == null) {
        return Left(TagsNotExistsFailure(tags: [tag.name]));
      }
      if (existingTag.name == newName) {
        return const Right(null);
      }
      final newNameExistingTag =
          await appDatabase.tagDao.getTagByName(newName);
      if (newNameExistingTag != null) {
        return Left(TagsDuplicateFailure(tags: [newName]));
      }
      await appDatabase.tagDao.renameTag(tag.name, newName);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changeTagColor({
    required TagEntity tag,
    required Color color,
  }) async {
    try {
      final existingTag = await appDatabase.tagDao.getTagByName(tag.name);
      if (existingTag == null) {
        return Left(TagsNotExistsFailure(tags: [tag.name]));
      }
      await appDatabase.tagDao.changeTagColor(tag.name, color.value);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setParentTag({
    required TagEntity tag,
    required TagEntity? parentTag,
  }) async {
    try {
      List<String> notExistingTags = [];
      final existingTag = await appDatabase.tagDao.getTagByName(tag.name);
      if (existingTag == null) {
        notExistingTags.add(tag.name);
      }
      if (parentTag != null) {
        final existingParentTag =
            await appDatabase.tagDao.getTagByName(parentTag.name);
        if (existingParentTag == null) {
          notExistingTags.add(parentTag.name);
        }
      }
      if (notExistingTags.isNotEmpty) {
        return Left(TagsNotExistsFailure(tags: notExistingTags));
      }
      final isCyclicDependency =
          await _isCyclicDependency(tag.name, parentTag?.name);
      if (!isCyclicDependency) {
        if (parentTag == null) {
          await appDatabase.tagDao.removeParentTag(tag.name);
        } else {
          await appDatabase.tagDao.setParentTag(tag.name, parentTag.name);
        }
      }
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTag({required TagEntity tag}) async {
    try {
      final existingTag = await appDatabase.tagDao.getTagByName(tag.name);
      if (existingTag != null) {
        await appDatabase.tagDao.deleteTag(existingTag);
        return const Right(null);
      } else {
        return Left(TagsNotExistsFailure(tags: [tag.name]));
      }
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TagEntity>>> getAllTags() async {
    try {
      final tagsModels = await appDatabase.tagDao.getAllTags();
      return Right(TagMapper.toEntities(tagsModels));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TagEntity>> getTagByName({
    required String name,
  }) async {
    try {
      final tagModel = await appDatabase.tagDao.getTagByName(name);
      if (tagModel != null) {
        return Right(TagMapper.toEntity(tagModel));
      } else {
        return Left(TagsNotExistsFailure(tags: [name]));
      }
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TagEntity>>> getTagsByNames({
    required List<String> names,
  }) async {
    try {
      final tagsModels = await appDatabase.tagDao.getTagsByNames(names);
      if (tagsModels.isNotEmpty) {
        return Right(TagMapper.toEntities(tagsModels));
      } else {
        return Left(TagsNotExistsFailure(tags: names));
      }
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
