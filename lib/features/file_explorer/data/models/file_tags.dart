import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

@Entity(tableName: 'file_tags', primaryKeys: [
  'file_id',
  'tag_id'
], foreignKeys: [
  ForeignKey(
      childColumns: ['file_id'], parentColumns: ['id'], entity: FileEntity),
  ForeignKey(childColumns: ['tag_id'], parentColumns: ['id'], entity: TagEntity)
])
class FileTags {
  @ColumnInfo(name: 'file_id')
  final int? fileId;
  @ColumnInfo(name: 'tag_id')
  final int? tagId;

  FileTags({this.fileId, this.tagId});
}
