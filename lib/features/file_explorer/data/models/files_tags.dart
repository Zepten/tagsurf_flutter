import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';

@Entity(tableName: 'files_tags', primaryKeys: [
  'file_path',
  'tag_name'
], foreignKeys: [
  ForeignKey(
      childColumns: ['file_path'], parentColumns: ['path'], entity: FileModel),
  ForeignKey(
      childColumns: ['tag_name'], parentColumns: ['name'], entity: TagModel)
])
class FilesTagsModel {
  @ColumnInfo(name: 'file_path')
  final String? filePath;

  @ColumnInfo(name: 'tag_name')
  final String? tagName;

  FilesTagsModel({this.filePath, this.tagName});
}
