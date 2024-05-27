import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file_tag_link.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_tag_link_repository.dart';

class FileTagLinkRepositoryImpl implements FileTagLinkRepository {
  final AppDatabase _appDatabase;

  FileTagLinkRepositoryImpl(this._appDatabase);

  @override
  Future<List<FileEntity>> getFilesByTag({required TagEntity tag}) async {
    final filesModels =
        await _appDatabase.fileTagLinkDao.getFilesByTagName(tag.name);
    return filesModels
        .map((fileModel) => FileEntity.fromModel(fileModel))
        .toList();
  }

  @override
  Future<List<TagEntity>> getTagsByFile({required FileEntity file}) async {
    final tagsModels =
        await _appDatabase.fileTagLinkDao.getTagsByFilePath(file.path);
    return tagsModels.map((tagModel) => TagEntity.fromModel(tagModel)).toList();
  }

  @override
  Future<void> linkFileAndTag(
      {required String filePath, required String tagName}) async {
    _appDatabase.fileTagLinkDao.insertFileTagLink(
        FileTagLinkModel(filePath: filePath, tagName: tagName));
  }

  @override
  Future<void> unlinkFileAndTag(
      {required String filePath, required String tagName}) async {
    _appDatabase.fileTagLinkDao.deleteFileTagLink(
        FileTagLinkModel(filePath: filePath, tagName: tagName));
  }

  @override
  Future<List<FileEntity>> getUntaggedFiles() async {
    final filesModels = await _appDatabase.fileTagLinkDao.getUntaggedFiles();
    return filesModels
        .map((fileModel) => FileEntity.fromModel(fileModel))
        .toList();
  }
}
