import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

@Entity(tableName: 'tags', foreignKeys: [
  ForeignKey(
      childColumns: ['parent_tag_name'],
      parentColumns: ['name'],
      entity: TagModel)
])
class TagModel extends Equatable {
  @PrimaryKey()
  final String name;

  @ColumnInfo(name: 'parent_tag_name')
  final String? parentTagName;

  @ColumnInfo(name: 'color_code_red')
  final int colorCodeRed;
  @ColumnInfo(name: 'color_code_green')
  final int colorCodeGreen;
  @ColumnInfo(name: 'color_code_blue')
  final int colorCodeBlue;

  const TagModel(
      {required this.name,
      this.parentTagName,
      required this.colorCodeRed,
      required this.colorCodeGreen,
      required this.colorCodeBlue});

  factory TagModel.fromEntity(TagEntity tagEntity) {
    return TagModel(
      name: tagEntity.name,
      parentTagName: tagEntity.parentTagName,
      colorCodeRed: tagEntity.colorCode.red,
      colorCodeGreen: tagEntity.colorCode.green,
      colorCodeBlue: tagEntity.colorCode.blue,
    );
  }

  @override
  List<Object?> get props =>
      [name, parentTagName, colorCodeRed, colorCodeGreen, colorCodeBlue];
}
