import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

class FileEntity extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? path;

  const FileEntity({required this.id, required this.path});

  @override
  List<Object?> get props => [id, path];
}
