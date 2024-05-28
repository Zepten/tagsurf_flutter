import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

// General failures

class FileSystemFailure extends Failure {
  @override
  List<Object?> get props => List.empty();
}

class DatabaseFailure extends Failure {
  @override
  List<Object?> get props => List.empty();
}

// Special failures

class FilesNotFoundFailure extends Failure {
  final List<String> paths;

  FilesNotFoundFailure({required this.paths});

  @override
  List<Object?> get props => [paths];
}
