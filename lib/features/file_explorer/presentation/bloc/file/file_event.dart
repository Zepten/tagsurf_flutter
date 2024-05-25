part of 'file_bloc.dart';

abstract class FileEvent extends Equatable {
  final FileEntity? file;
  final List<FileEntity>? files;

  const FileEvent({this.file, this.files});

  @override
  List<Object?> get props => [file!];
}

class GetTrackedFilesEvent extends FileEvent {
  const GetTrackedFilesEvent();
}

class TrackFilesEvent extends FileEvent {
  const TrackFilesEvent(List<FileEntity> files) : super(files: files);
}

class TrackFileEvent extends FileEvent {
  const TrackFileEvent(FileEntity file) : super(file: file);
}

class UntrackFileEvent extends FileEvent {
  const UntrackFileEvent(FileEntity file) : super(file: file);
}
