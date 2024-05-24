import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

abstract class FileTagRepository {
  Future<List<FileEntity>> getFilesByTag(TagEntity tag);
  Future<List<TagEntity>> getTagsByFile(FileEntity file);
  Future<void> linkFileAndTag(FileEntity file, TagEntity tag);
  Future<void> updateLinkFileAndTag(FileEntity file, TagEntity tag);
  Future<void> unlinkFileAndTag(FileEntity file, TagEntity tag);
}
