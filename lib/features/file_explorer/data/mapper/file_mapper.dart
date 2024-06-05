import 'package:tagsurf_flutter/features/file_explorer/core/util/file_utils.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

class FileMapper {
  static FileModel toModel(FileEntity fileEntity) {
    return FileModel(
      path: fileEntity.path,
      name: FileUtils.basename(fileEntity.path).toLowerCase(),
      dateTimeAdded: fileEntity.dateTimeAdded,
    );
  }

  static FileEntity toEntity(FileModel fileModel) {
    return FileEntity(
      path: fileModel.path,
      dateTimeAdded: fileModel.dateTimeAdded,
    );
  }

  static List<FileModel> toModels(List<FileEntity> filesEntities) {
    return filesEntities
        .map((fileEntity) => FileMapper.toModel(fileEntity))
        .toList();
  }

  static List<FileEntity> toEntities(List<FileModel> filesModels) {
    return filesModels
        .map((fileModel) => FileMapper.toEntity(fileModel))
        .toList();
  }
}
