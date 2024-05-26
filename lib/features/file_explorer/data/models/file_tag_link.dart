import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';

@Entity(tableName: 'file_tag_link')
class FileTagLinkModel extends Equatable {
  @ColumnInfo(name: 'file_path')
  @PrimaryKey()
  @ForeignKey(
      childColumns: ['file_path'], parentColumns: ['path'], entity: FileModel)
  final String filePath;

  @ColumnInfo(name: 'tag_name')
  @PrimaryKey()
  @ForeignKey(
      childColumns: ['tag_name'], parentColumns: ['name'], entity: TagModel)
  final String tagName;

  const FileTagLinkModel({required this.filePath, required this.tagName});

  @override
  List<Object?> get props => [filePath, tagName];
}
