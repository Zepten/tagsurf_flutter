import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';

@Entity(tableName: 'file_tag_link', primaryKeys: [
  'file_path',
  'tag_name'
], foreignKeys: [
  ForeignKey(
      childColumns: ['file_path'],
      parentColumns: ['path'],
      entity: FileModel,
      onUpdate: ForeignKeyAction.cascade,
      onDelete: ForeignKeyAction.cascade),
  ForeignKey(
      childColumns: ['tag_name'],
      parentColumns: ['name'],
      entity: TagModel,
      onUpdate: ForeignKeyAction.cascade,
      onDelete: ForeignKeyAction.cascade),
], indices: [
  Index(value: ['file_path']),
  Index(value: ['tag_name'])
])
class FileTagLinkModel extends Equatable {
  @ColumnInfo(name: 'file_path')
  final String filePath;

  @ColumnInfo(name: 'tag_name')
  final String tagName;

  @ColumnInfo(name: 'date_time_added')
  final DateTime dateTimeAdded;

  const FileTagLinkModel({
    required this.filePath,
    required this.tagName,
    required this.dateTimeAdded,
  });

  @override
  List<Object?> get props => [filePath, tagName, dateTimeAdded];
}
