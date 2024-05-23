import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/files_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_tag_repository.dart';

class FileTagRepositoryImpl implements FileTagRepository {
  final AppDatabase _appDatabase;

  FileTagRepositoryImpl(this._appDatabase);

  @override
  Future<List<FileEntity?>> getFilesByTag(TagEntity tag) async {
    final filesPaths =
        await _appDatabase.fileTagsDao.getFilesPathsByTag(tag.id!);
    final files = Future.wait(
      filesPaths
          .map((filePath) => _appDatabase.fileDao.getFileByPath(filePath)),
    );
    return files;
  }

  @override
  Future<List<TagEntity?>> getTagsByFile(FileEntity file) async {
    final tagsIds = await _appDatabase.fileTagsDao.getTagsIdsByFilePath(file.path!);
    final tags = Future.wait(
      tagsIds
          .map((tagId) => _appDatabase.tagDao.getTagById(tagId)),
    );
    return tags;
  }

  @override
  Future<void> linkFileAndTag(FileEntity file, TagEntity tag) async {
    _appDatabase.fileTagsDao
        .insertFileTags(FilesTagsModel(filePath: file.path, tagId: tag.id));
  }

  @override
  Future<void> updateLinkFileAndTag(FileEntity file, TagEntity tag) async {
    _appDatabase.fileTagsDao
        .updateFileTags(FilesTagsModel(filePath: file.path, tagId: tag.id));
  }

  @override
  Future<void> unlinkFileAndTag(FileEntity file, TagEntity tag) async {
    _appDatabase.fileTagsDao
        .deleteFileTags(FilesTagsModel(filePath: file.path, tagId: tag.id));
  }
}
