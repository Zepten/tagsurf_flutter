part of 'file_bloc.dart';

abstract class FileState extends Equatable {
  final List<FileEntity>? files;

  const FileState({this.files});

  @override
  List<Object> get props => [files!];
}

final class FileLoadingState extends FileState {
  const FileLoadingState();
}

final class FileLoadedState extends FileState {
  const FileLoadedState(List<FileEntity> files) : super(files: files);
}
