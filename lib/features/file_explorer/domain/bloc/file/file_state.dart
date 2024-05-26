part of 'file_bloc.dart';

abstract class FileState extends Equatable {}

final class FileLoadingState extends FileState {
  @override
  List<Object?> get props => List.empty();
}

final class FileLoadedState extends FileState {
  final List<FileEntity> files;

  FileLoadedState({required this.files});

  @override
  List<Object?> get props => [files];
}
