import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

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

  @override
  List<Object?> get props => [path, name];
}
