part of 'file_bloc.dart';

abstract class FileState extends Equatable {}

final class FilesLoadingState extends FileState {
  @override
  List<Object?> get props => List.empty();
}

final class FilesLoadedState extends FileState {
  final List<FileEntity> files;

  FilesLoadedState({required this.files});

  @override
  List<Object?> get props => [files];
}

final class FilesErrorState extends FileState {
  final Failure failure;

  FilesErrorState({required this.failure});

  @override
  List<Object?> get props => [failure];
}