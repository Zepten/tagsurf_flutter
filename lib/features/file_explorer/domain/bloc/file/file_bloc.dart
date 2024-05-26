import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/get_files_by_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/get_untagged_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/get_tracked_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/track_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/track_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/untrack_file.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  // File UseCases
  final GetTrackedFilesUseCase _getTrackedFilesUseCase;
  final TrackFileUseCase _trackFileUseCase;
  final UntrackFileUseCase _untrackFileUseCase;
  final TrackFilesUseCase _trackMultipleFilesUseCase;
  // File-tag linking UseCases
  final GetFilesByTagUseCase _getFilesByTagUseCase;
  final GetUntaggedFilesUseCase _getUntaggedFilesUseCase;

  FileBloc(
      this._getTrackedFilesUseCase,
      this._trackFileUseCase,
      this._untrackFileUseCase,
      this._trackMultipleFilesUseCase,
      this._getFilesByTagUseCase,
      this._getUntaggedFilesUseCase)
      : super(FileLoadingState()) {
    // File events
    on<GetTrackedFilesEvent>(onGetTrackedFiles);
    on<TrackFileEvent>(onTrackFile);
    on<UntrackFileEvent>(onUntrackFile);
    on<TrackFilesEvent>(onTrackFiles);

    // File-tag linking events
    on<GetFilesByTagEvent>(onGetFilesByTag);
    on<GetUntaggedFilesEvent>(onGetUntaggedFiles);
  }

  // File business logic
  void onGetTrackedFiles(
      GetTrackedFilesEvent event, Emitter<FileState> emit) async {
    final files = await _getTrackedFilesUseCase();
    emit(FilesLoadedState(files: files));
  }

  void onTrackFile(TrackFileEvent event, Emitter<FileState> emit) async {
    await _trackFileUseCase(params: event.file);
    final files = await _getTrackedFilesUseCase();
    emit(FilesLoadedState(files: files));
  }

  void onTrackFiles(TrackFilesEvent event, Emitter<FileState> emit) async {
    await _trackMultipleFilesUseCase(params: event.files);
    final files = await _getTrackedFilesUseCase();
    emit(FilesLoadedState(files: files));
  }

  void onUntrackFile(UntrackFileEvent event, Emitter<FileState> emit) async {
    await _untrackFileUseCase(params: event.file);
    final files = await _getTrackedFilesUseCase();
    emit(FilesLoadedState(files: files));
  }

  // File-tag linking business logic
  void onGetFilesByTag(
      GetFilesByTagEvent event, Emitter<FileState> emit) async {
    final files = await _getFilesByTagUseCase(params: event.tag);
    emit(FilesLoadedState(files: files));
  }

  void onGetUntaggedFiles(
      GetUntaggedFilesEvent event, Emitter<FileState> emit) async {
    final files = await _getUntaggedFilesUseCase();
    emit(FilesLoadedState(files: files));
  }
}
