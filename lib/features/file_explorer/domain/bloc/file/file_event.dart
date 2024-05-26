part of 'file_bloc.dart';

abstract class FileEvent extends Equatable {}

// File events
class GetTrackedFilesEvent extends FileEvent {
  @override
  List<Object?> get props => List.empty();
}

class TrackFilesEvent extends FileEvent {
  final List<FileEntity> files;

  TrackFilesEvent({required this.files});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class TrackFileEvent extends FileEvent {
  final FileEntity file;

  TrackFileEvent({required this.file});

  @override
  List<Object?> get props => [file];
}

class UntrackFileEvent extends FileEvent {
  final FileEntity file;

  UntrackFileEvent({required this.file});

  @override
  List<Object?> get props => [file];
}

// File-tag linking events
class GetFilesByTagEvent extends FileEvent {
  final TagEntity tag;

  GetFilesByTagEvent({required this.tag});

  @override
  List<Object?> get props => [tag];
}
