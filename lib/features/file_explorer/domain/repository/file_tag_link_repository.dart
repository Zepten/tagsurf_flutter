import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

abstract class FileTagLinkRepository {
  Future<List<FileEntity>> getFilesByTag({required TagEntity tag});
  Future<List<TagEntity>> getTagsByFile({required FileEntity file});
  Future<List<FileEntity>> getUntaggedFiles();
  Future<void> linkFileAndTag({required String filePath, required String tagName});
  Future<void> unlinkFileAndTag({required String filePath, required String tagName});
  // TODO: batch insert methods
}
