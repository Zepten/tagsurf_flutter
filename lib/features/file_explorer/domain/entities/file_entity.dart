import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';

class FileEntity extends Equatable {
  final String path;

  const FileEntity({required this.path});

  factory FileEntity.fromModel(FileModel fileModel) {
    return FileEntity(path: fileModel.path);
  }

  @override
  List<Object?> get props => [path];
}
