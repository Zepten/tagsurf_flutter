import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

@Entity(tableName: 'files_tags', primaryKeys: [
  'file_path',
  'tag_id'
], foreignKeys: [
  ForeignKey(
      childColumns: ['file_path'], parentColumns: ['path'], entity: FileEntity),
  ForeignKey(childColumns: ['tag_id'], parentColumns: ['id'], entity: TagEntity)
])
class FilesTagsModel {
  @ColumnInfo(name: 'file_path')
  final String? filePath;
  @ColumnInfo(name: 'tag_id')
  final int? tagId;

  FilesTagsModel({this.filePath, this.tagId});
}
