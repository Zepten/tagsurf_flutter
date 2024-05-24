import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

@Entity(tableName: 'files', primaryKeys: ['path'])
class FileModel extends FileEntity {
  const FileModel({required super.path});

  factory FileModel.fromEntity(FileEntity fileEntity) {
    return FileModel(path: fileEntity.path);
  }
}
