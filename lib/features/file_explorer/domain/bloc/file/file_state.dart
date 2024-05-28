part of 'file_bloc.dart';

abstract class FileState extends Equatable {}

final class FilesLoadingState extends FileState {
  @override
  List<Object?> get props => List.empty();
}

final class FilesLoadedState extends FileState {
  final Either<Failure, List<FileEntity>> files;

  FilesLoadedState({required this.files});

  @override
  List<Object?> get props => [files];
}
