import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/file_utils.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

@Entity(tableName: 'files', indices: [
  Index(value: ['path']),
  Index(value: ['name']),
])
class FileModel extends Equatable {
  @PrimaryKey()
  final String path;
  final String name;
  @ColumnInfo(name: 'date_time_added')
  final DateTime dateTimeAdded;

  const FileModel({
    required this.path,
    required this.name,
    required this.dateTimeAdded,
  });

  factory FileModel.fromEntity(FileEntity fileEntity) {
    return FileModel(
      path: fileEntity.path,
      name: FileUtils.basename(fileEntity.path).toLowerCase(),
      dateTimeAdded: fileEntity.dateTimeAdded,
    );
  }

  @override
  List<Object?> get props => [path, name, dateTimeAdded];
}
