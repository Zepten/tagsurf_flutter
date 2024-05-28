import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

// === General failures ===

class FileSystemFailure extends Failure {
  @override
  List<Object?> get props => List.empty();
}

class DatabaseFailure extends Failure {
  @override
  List<Object?> get props => List.empty();
}

// Special failures for files (database)

class FilesNotExistsFailure extends Failure {
  final List<String> files;

  FilesNotExistsFailure({required this.files});

  @override
  List<Object?> get props => [files];
}

class FileNotExistsFailure extends Failure {
  final String file;

  FileNotExistsFailure({required this.file});

  @override
  List<Object?> get props => [file];
}

class FileDuplicateFailure extends Failure {
  final String file;

  FileDuplicateFailure({required this.file});

  @override
  List<Object?> get props => [file];
}

class FilesDuplicateFailure extends Failure {
  final List<String> files;

  FilesDuplicateFailure({required this.files});

  @override
  List<Object?> get props => [files];
}

// Special failures for files (file system)

class FilesNotInFileSystemFailure extends Failure {
  final List<String> files;

  FilesNotInFileSystemFailure({required this.files});

  @override
  List<Object?> get props => [files];
}

class FileNotInFileSystemFailure extends Failure {
  final String file;

  FileNotInFileSystemFailure({required this.file});

  @override
  List<Object?> get props => [file];
}

// Special failures for tags
class TagDuplicateFailure extends Failure {
  final String tag;

  TagDuplicateFailure({required this.tag});

  @override
  List<Object?> get props => [tag];
}

class TagsDuplicateFailure extends Failure {
  final List<String> tags;

  TagsDuplicateFailure({required this.tags});

  @override
  List<Object?> get props => [tags];
}

class TagNotExistsFailure extends Failure {
  final String tag;

  TagNotExistsFailure({required this.tag});

  @override
  List<Object?> get props => [tag];
}

class TagsNotExistsFailure extends Failure {
  final List<String> tags;

  TagsNotExistsFailure({required this.tags});

  @override
  List<Object?> get props => [tags];
}

class InvalidTagFailure extends Failure {
  @override
  List<Object?> get props => List.empty();
}