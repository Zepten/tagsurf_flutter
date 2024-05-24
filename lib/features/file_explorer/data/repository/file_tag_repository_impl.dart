import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/files_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_tag_repository.dart';

class FileTagRepositoryImpl implements FileTagRepository {
  final AppDatabase _appDatabase;

  FileTagRepositoryImpl(this._appDatabase);

  @override
  Future<List<FileEntity>> getFilesByTag(TagEntity tag) async {
    final filesModels =
        await _appDatabase.fileTagsDao.getFilesByTagName(tag.name!);
    return filesModels
        .map((fileModel) => FileEntity.fromModel(fileModel))
        .toList(growable: false);
  }

  @override
  Future<List<TagEntity>> getTagsByFile(FileEntity file) async {
    final tagsModels =
        await _appDatabase.fileTagsDao.getTagsByFilePath(file.path!);
    return tagsModels
        .map((tagModel) => TagEntity.fromModel(tagModel))
        .toList(growable: false);
  }

  @override
  Future<void> linkFileAndTag(FileEntity file, TagEntity tag) async {
    _appDatabase.fileTagsDao
        .insertFileTags(FilesTagsModel(filePath: file.path, tagName: tag.name));
  }

  @override
  Future<void> updateLinkFileAndTag(FileEntity file, TagEntity tag) async {
    _appDatabase.fileTagsDao
        .updateFileTags(FilesTagsModel(filePath: file.path, tagName: tag.name));
  }

  @override
  Future<void> unlinkFileAndTag(FileEntity file, TagEntity tag) async {
    _appDatabase.fileTagsDao
        .deleteFileTags(FilesTagsModel(filePath: file.path, tagName: tag.name));
  }
}
