import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';

class FileSystemFailure extends Failure {
  final String message;

  FileSystemFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class DatabaseFailure extends Failure {
  final String message;

  DatabaseFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
