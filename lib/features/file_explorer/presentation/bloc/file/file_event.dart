part of 'file_bloc.dart';

abstract class FileEvent extends Equatable {}

class GetFilesEvent extends FileEvent {
  final bool isFiltering;
  final List<String> filters;
  final String searchQuery;

  GetFilesEvent({
    required this.isFiltering,
    required this.filters,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [filters];
}

class TrackFilesEvent extends FileEvent {
  final List<FileEntity> files;
  final bool isFiltering;
  final List<String> filters;
  final String searchQuery;

  TrackFilesEvent({
    required this.files,
    required this.isFiltering,
    required this.filters,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [files, isFiltering, filters];
}

class UntrackFilesEvent extends FileEvent {
  final List<FileEntity> files;
  final bool isFiltering;
  final List<String> filters;
  final String searchQuery;

  UntrackFilesEvent({
    required this.files,
    required this.isFiltering,
    required this.filters,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [files];
}

class OpenFileEvent extends FileEvent {
  final FileEntity file;

  OpenFileEvent({required this.file});

  @override
  List<Object?> get props => [file];
}
