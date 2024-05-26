import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

@Entity(tableName: 'files')
class FileModel extends Equatable {
  @PrimaryKey()
  final String path;

  const FileModel({required this.path});

  factory FileModel.fromEntity(FileEntity fileEntity) {
    return FileModel(path: fileEntity.path);
  }

  @override
  List<Object?> get props => [path];
}
