import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

class FileEntity extends Equatable {
  @PrimaryKey()
  final String? path;

  const FileEntity({required this.path});

  @override
  List<Object?> get props => [path];
}
