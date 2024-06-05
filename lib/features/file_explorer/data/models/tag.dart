import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

@Entity(tableName: 'tags', foreignKeys: [
  ForeignKey(
      childColumns: ['parent_tag_name'],
      parentColumns: ['name'],
      entity: TagModel,
      onUpdate: ForeignKeyAction.cascade,
      onDelete: ForeignKeyAction.setNull)
], indices: [
  Index(value: ['name']),
  Index(value: ['parent_tag_name'])
])
class TagModel extends Equatable {
  @PrimaryKey()
  final String name;

  @ColumnInfo(name: 'parent_tag_name')
  final String? parentTagName;

  @ColumnInfo(name: 'color')
  final Color color;

  @ColumnInfo(name: 'date_time_added')
  final DateTime dateTimeAdded;

  const TagModel({
    required this.name,
    this.parentTagName,
    required this.color,
    required this.dateTimeAdded,
  });

  factory TagModel.fromEntity(TagEntity tagEntity) {
    return TagModel(
      name: tagEntity.name,
      parentTagName: tagEntity.parentTagName,
      color: tagEntity.color,
      dateTimeAdded: tagEntity.dateTimeAdded,
    );
  }

  @override
  List<Object?> get props => [name, parentTagName, color, dateTimeAdded];
}
