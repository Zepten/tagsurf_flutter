import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';

class FileEntity extends Equatable {
  final String path;
  final DateTime dateTimeAdded;

  const FileEntity({
    required this.path,
    required this.dateTimeAdded,
  });

  factory FileEntity.fromModel(FileModel fileModel) {
    return FileEntity(
      path: fileModel.path,
      dateTimeAdded: fileModel.dateTimeAdded,
    );
  }

  @override
  List<Object?> get props => [path];
}
