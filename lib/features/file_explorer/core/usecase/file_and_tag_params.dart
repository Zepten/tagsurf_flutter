import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

class FileAndTagParams {
  final FileEntity file;
  final TagEntity tag;

  FileAndTagParams({required this.file, required this.tag});
}
