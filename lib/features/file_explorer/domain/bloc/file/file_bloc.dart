import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/get_files_by_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/get_untagged_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/get_tracked_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/open_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/track_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/untrack_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/update_file.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  // File UseCases
  final GetTrackedFilesUseCase _getTrackedFilesUseCase;
  final UpdateFileUseCase _updateFileUseCase;
  final UntrackFileUseCase _untrackFileUseCase;
  final TrackFilesUseCase _trackMultipleFilesUseCase;
  final OpenFileUseCase _openFileUseCase;
  // File-tag linking UseCases
  final GetFilesByTagsUseCase _getFilesByTagsUseCase;
  final GetUntaggedFilesUseCase _getUntaggedFilesUseCase;

  FileBloc(
    this._getTrackedFilesUseCase,
    this._updateFileUseCase,
    this._untrackFileUseCase,
    this._trackMultipleFilesUseCase,
    this._getFilesByTagsUseCase,
    this._getUntaggedFilesUseCase,
    this._openFileUseCase,
  ) : super(FilesLoadingState()) {
    on<GetFilesEvent>(onGetFiles);
    on<TrackFilesEvent>(onTrackFiles);
    on<UpdateFileEvent>(onUpdateFile);
    on<UntrackFileEvent>(onUntrackFile);
    on<OpenFileEvent>(onOpenFile);
  }

  void onGetFiles(
    GetFilesEvent event,
    Emitter<FileState> emit,
  ) async {
    emit(FilesLoadingState());
    Either<Failure, List<FileEntity>> files;
    if (event.isFiltering) {
      if (event.filters.isEmpty) {
        files = await _getUntaggedFilesUseCase(params: event.searchQuery);
      } else {
        files = await _getFilesByTagsUseCase(
            params: GetFilesByTagsUseCaseParams(
                tagsNames: event.filters, searchQuery: event.searchQuery));
      }
    } else {
      files = await _getTrackedFilesUseCase(params: event.searchQuery);
    }
    files.fold(
      (failure) => emit(FilesErrorState(failure: failure)),
      (files) => emit(FilesLoadedState(files: files)),
    );
  }

  void onTrackFiles(
    TrackFilesEvent event,
    Emitter<FileState> emit,
  ) async {
    final result = await _trackMultipleFilesUseCase(params: event.files);
    result.fold(
      (failure) => emit(FilesErrorState(failure: failure)),
      (success) => add(
        GetFilesEvent(
          isFiltering: event.isFiltering,
          filters: event.filters,
          searchQuery: event.searchQuery,
        ),
      ),
    );
  }

  void onUpdateFile(
    UpdateFileEvent event,
    Emitter<FileState> emit,
  ) async {
    final result = await _updateFileUseCase(params: event.file);
    result.fold(
      (failure) => emit(FilesErrorState(failure: failure)),
      (success) => add(
        GetFilesEvent(
          isFiltering: event.isFiltering,
          filters: event.filters,
          searchQuery: event.searchQuery,
        ),
      ),
    );
  }

  void onUntrackFile(
    UntrackFileEvent event,
    Emitter<FileState> emit,
  ) async {
    final result = await _untrackFileUseCase(params: event.file);
    result.fold(
      (failure) => emit(FilesErrorState(failure: failure)),
      (success) => add(
        GetFilesEvent(
          isFiltering: event.isFiltering,
          filters: event.filters,
          searchQuery: event.searchQuery,
        ),
      ),
    );
  }

  void onOpenFile(OpenFileEvent event, Emitter<FileState> emit) async {
    final result = await _openFileUseCase(params: event.file);
    result.fold(
      (failure) => emit(FilesErrorState(failure: failure)),
      (success) => null,
    );
  }
}
