import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/domain/entities/file_entity.dart';

@Entity(tableName: 'files')
class FileModel extends FileEntity {
  const FileModel(
      {required super.id, required super.path});

  factory FileModel.fromEntity(FileEntity fileEntity) {
    return FileModel(
        id: fileEntity.id, path: fileEntity.path);
  }
}
