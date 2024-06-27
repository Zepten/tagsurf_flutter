import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/exceptions.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/file_tag_links_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/files_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/general_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/tags_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/search_query_formatter.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/mapper/file_mapper.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/mapper/tag_mapper.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file_tag_link.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_tag_link_repository.dart';

class FileTagLinkRepositoryImpl implements FileTagLinkRepository {
  final AppDatabase appDatabase;

  FileTagLinkRepositoryImpl(this.appDatabase);

  @override
  Future<Either<Failure, List<FileEntity>>> getFilesByTags(
      {required List<String> tagsNames, required String searchQuery}) async {
    try {
      final formattedSearchQuery =
          SearchQueryFormatter.formatForSql(searchQuery);
      final filesModels = await appDatabase.fileTagLinkDao
          .getFilesByTagsNames(tagsNames, formattedSearchQuery);
      return Right(FileMapper.toEntities(filesModels));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TagEntity>>> getTagsByFile(
      {required FileEntity file}) async {
    try {
      final tagsModels =
          await appDatabase.fileTagLinkDao.getTagsByFilePath(file.path);
      return Right(TagMapper.toEntities(tagsModels));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> linkFileAndTag(
      {required String filePath, required String tagName}) async {
    try {
      final existingFile = await appDatabase.fileDao.getFileByPath(filePath);
      if (existingFile == null) {
        return Left(FilesNotExistsFailure(files: [filePath]));
      }
      final existingTag = await appDatabase.tagDao.getTagByName(tagName);
      if (existingTag == null) {
        return Left(TagsNotExistsFailure(tags: [tagName]));
      }
      final existingLink =
          await appDatabase.fileTagLinkDao.getFileTagLink(filePath, tagName);
      if (existingLink == null) {
        await appDatabase.fileTagLinkDao.insertFileTagLink(FileTagLinkModel(
          filePath: filePath,
          tagName: tagName,
          dateTimeAdded: DateTime.now(),
        ));
      }
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> linkOrCreateTag(
      {required String filePath, required String tagName}) async {
    try {
      final existingFile = await appDatabase.fileDao.getFileByPath(filePath);
      if (existingFile == null) {
        return Left(FilesNotExistsFailure(files: [filePath]));
      }
      final existingTag = await appDatabase.tagDao.getTagByName(tagName);
      if (existingTag == null) {
        final defaultTagEntity = TagEntity.createDefault(tagName);
        await appDatabase.tagDao.insertTags([TagMapper.toModel(defaultTagEntity)]);
        return await linkFileAndTag(
            filePath: filePath, tagName: defaultTagEntity.name);
      } else {
        return await linkFileAndTag(
            filePath: filePath, tagName: existingTag.name);
      }
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unlinkFileAndTag(
      {required String filePath, required String tagName}) async {
    try {
      final existingLink =
          await appDatabase.fileTagLinkDao.getFileTagLink(filePath, tagName);
      if (existingLink != null) {
        await appDatabase.fileTagLinkDao.deleteFileTagLink(existingLink);
        return const Right(null);
      } else {
        return Left(LinkNotExistFailure(file: filePath, tag: tagName));
      }
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FileEntity>>> getUntaggedFiles(
      {required String searchQuery}) async {
    try {
      final formattedSearchQuery =
          SearchQueryFormatter.formatForSql(searchQuery);
      final filesModels = await appDatabase.fileTagLinkDao
          .getUntaggedFiles(formattedSearchQuery);
      return Right(FileMapper.toEntities(filesModels));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
