import 'package:equatable/equatable.dart';

class FileEntity extends Equatable {
  final String path;
  final DateTime dateTimeAdded;

  const FileEntity({
    required this.path,
    required this.dateTimeAdded,
  });

  @override
  List<Object?> get props => [path];
}
