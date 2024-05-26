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
  Future<void> linkFileAndTag({required FileEntity file, required TagEntity tag}) async {
    _appDatabase.fileTagLinkDao.insertFileTagLink(
        FileTagLinkModel(filePath: file.path, tagName: tag.name));
  }

  @override
  Future<void> unlinkFileAndTag({required FileEntity file, required TagEntity tag}) async {
    _appDatabase.fileTagLinkDao.deleteFileTagLink(
        FileTagLinkModel(filePath: file.path, tagName: tag.name));
  }
}
