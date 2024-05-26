import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

abstract class FileTagLinkRepository {
  Future<List<FileEntity>> getFilesByTag({required TagEntity tag});
  Future<List<TagEntity>> getTagsByFile({required FileEntity file});
  Future<void> linkFileAndTag({required FileEntity file, required TagEntity tag});
  Future<void> unlinkFileAndTag({required FileEntity file, required TagEntity tag});
  // TODO: batch insert methods
}
