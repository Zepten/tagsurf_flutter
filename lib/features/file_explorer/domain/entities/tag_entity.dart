import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

class TagEntity extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? name;
  @ColumnInfo(name: 'parent_tag_id')
  final int? parentTag;
  @ColumnInfo(name: 'color_code')
  final String colorCode;

  const TagEntity(
      {required this.id, required this.name, required this.parentTag, required this.colorCode});

  @override
  List<Object?> get props => [id, name, parentTag, colorCode];
}
