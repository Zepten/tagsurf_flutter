import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/get_files_by_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/get_untagged_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/get_tracked_files.dart';
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
  ) : super(FilesLoadingState()) {
    // File events
    on<GetTrackedFilesEvent>(onGetTrackedFiles);
    on<TrackFilesEvent>(onTrackFiles);
    on<UpdateFileEvent>(onUpdateFile);
    on<UntrackFileEvent>(onUntrackFile);

    // File-tag linking events
    on<GetFilesByTagsEvent>(onGetFilesByTags);
    on<GetUntaggedFilesEvent>(onGetUntaggedFiles);
  }

  // File business logic
  void onGetTrackedFiles(
      GetTrackedFilesEvent event, Emitter<FileState> emit) async {
    emit(FilesLoadingState());
    final files = await _getTrackedFilesUseCase();
    files.fold(
      (failure) => emit(FilesErrorState(failure: failure)),
      (files) => emit(FilesLoadedState(files: files)),
    );
  }

  void onTrackFiles(TrackFilesEvent event, Emitter<FileState> emit) async {
    emit(FilesLoadingState());
    final result = await _trackMultipleFilesUseCase(params: event.files);
    final filesResult = await _getTrackedFilesUseCase();
    result.fold(
      (resultFailure) => emit(FilesErrorState(failure: resultFailure)),
      (resultSuccess) {
        filesResult.fold(
            (getFilesFailure) =>
                emit(FilesErrorState(failure: getFilesFailure)),
            (files) => emit(FilesLoadedState(files: files)));
      },
    );
  }

  void onUpdateFile(UpdateFileEvent event, Emitter<FileState> emit) async {
    emit(FilesLoadingState());
    final result = await _updateFileUseCase(params: event.file);
    final filesResult = await _getTrackedFilesUseCase();
    result.fold(
      (resultFailure) => emit(FilesErrorState(failure: resultFailure)),
      (resultSuccess) {
        filesResult.fold(
            (getFilesFailure) =>
                emit(FilesErrorState(failure: getFilesFailure)),
            (files) => emit(FilesLoadedState(files: files)));
      },
    );
  }

  void onUntrackFile(UntrackFileEvent event, Emitter<FileState> emit) async {
    emit(FilesLoadingState());
    final result = await _untrackFileUseCase(params: event.file);
    final filesResult = await _getTrackedFilesUseCase();
    result.fold(
      (resultFailure) => emit(FilesErrorState(failure: resultFailure)),
      (resultSuccess) {
        filesResult.fold(
            (getFilesFailure) =>
                emit(FilesErrorState(failure: getFilesFailure)),
            (files) => emit(FilesLoadedState(files: files)));
      },
    );
  }

  // File-tag linking business logic
  void onGetFilesByTags(
      GetFilesByTagsEvent event, Emitter<FileState> emit) async {
    emit(FilesLoadingState());
    final files = await _getFilesByTagsUseCase(params: event.tags);
    files.fold(
      (failure) => emit(FilesErrorState(failure: failure)),
      (files) => emit(FilesLoadedState(files: files)),
    );
  }

  void onGetUntaggedFiles(
      GetUntaggedFilesEvent event, Emitter<FileState> emit) async {
    emit(FilesLoadingState());
    final files = await _getUntaggedFilesUseCase();
    files.fold(
      (failure) => emit(FilesErrorState(failure: failure)),
      (files) => emit(FilesLoadedState(files: files)),
    );
  }
}
