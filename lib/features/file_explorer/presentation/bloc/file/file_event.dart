part of 'file_bloc.dart';

abstract class FileEvent extends Equatable {}

class GetFilesEvent extends FileEvent {
  final FilteringModes filteringMode;
  final List<String> filters;
  final String searchQuery;

  GetFilesEvent({
    required this.filteringMode,
    required this.filters,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [filteringMode, filters, searchQuery];
}

class TrackFilesEvent extends FileEvent {
  final List<FileEntity> files;
  final FilteringModes filteringMode;
  final List<String> filters;
  final String searchQuery;

  TrackFilesEvent({
    required this.files,
    required this.filteringMode,
    required this.filters,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [files, filteringMode, filters, searchQuery];
}

class UntrackFilesEvent extends FileEvent {
  final List<FileEntity> files;
  final FilteringModes filteringMode;
  final List<String> filters;
  final String searchQuery;

  UntrackFilesEvent({
    required this.files,
    required this.filteringMode,
    required this.filters,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [files, filteringMode, filters, searchQuery];
}

class OpenFileEvent extends FileEvent {
  final FileEntity file;

  OpenFileEvent({required this.file});

  @override
  List<Object?> get props => [file];
}
