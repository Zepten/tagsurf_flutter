import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';

// Special failures for files (file system)

class FilesNotInFileSystemFailure extends Failure {
  final List<String> files;

  FilesNotInFileSystemFailure({required this.files});

  @override
  List<Object?> get props => [files];
}

// Special failures for files (database)

class FilesNotExistsFailure extends Failure {
  final List<String> files;

  FilesNotExistsFailure({required this.files});

  @override
  List<Object?> get props => [files];
}

class FilesDuplicateFailure extends Failure {
  final List<String> files;

  FilesDuplicateFailure({required this.files});

  @override
  List<Object?> get props => [files];
}
