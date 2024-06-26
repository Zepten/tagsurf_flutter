import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/filtering/filtering_modes.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/get_files_by_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/get_untagged_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/get_tracked_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/open_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/track_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/files/untrack_file.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  // File UseCases
  final GetTrackedFilesUseCase getTrackedFilesUseCase;
  final UntrackFileUseCase untrackFileUseCase;
  final TrackFilesUseCase trackMultipleFilesUseCase;
  final OpenFileUseCase openFileUseCase;
  // File-tag linking UseCases
  final GetFilesByTagsUseCase getFilesByTagsUseCase;
  final GetUntaggedFilesUseCase getUntaggedFilesUseCase;

  FileBloc(
    this.getTrackedFilesUseCase,
    this.untrackFileUseCase,
    this.trackMultipleFilesUseCase,
    this.getFilesByTagsUseCase,
    this.getUntaggedFilesUseCase,
    this.openFileUseCase,
  ) : super(FilesLoadingState()) {
    on<GetFilesEvent>(onGetFiles);
    on<TrackFilesEvent>(onTrackFiles);
    on<UntrackFilesEvent>(onUntrackFile);
    on<OpenFileEvent>(onOpenFile);
  }

  void onGetFiles(
    GetFilesEvent event,
    Emitter<FileState> emit,
  ) async {
    emit(FilesLoadingState());
    Either<Failure, List<FileEntity>> files;
    switch (event.filteringMode) {
      // Все файлы (с тегами и без)
      case FilteringModes.all:
        files = await getTrackedFilesUseCase(params: event.searchQuery);
        break;
      // Все ИЛИ некоторые файлы у которых есть теги
      case FilteringModes.allTagged || FilteringModes.someTagged:
        files = await getFilesByTagsUseCase(
          params: GetFilesByTagsUseCaseParams(
            tagsNames: event.filters,
            searchQuery: event.searchQuery,
          ),
        );
        break;
      // Все файлы у которых нет тегов
      case FilteringModes.allUntagged:
        files = await getUntaggedFilesUseCase(params: event.searchQuery);
        break;
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
    final result = await trackMultipleFilesUseCase(params: event.files);
    result.fold(
      (failure) => emit(FilesErrorState(failure: failure)),
      (success) => add(
        GetFilesEvent(
          filteringMode: event.filteringMode,
          filters: event.filters,
          searchQuery: event.searchQuery,
        ),
      ),
    );
  }

  void onUntrackFile(
    UntrackFilesEvent event,
    Emitter<FileState> emit,
  ) async {
    final result = await untrackFileUseCase(params: event.files);
    result.fold(
      (failure) => emit(FilesErrorState(failure: failure)),
      (success) => add(
        GetFilesEvent(
          filteringMode: event.filteringMode,
          filters: event.filters,
          searchQuery: event.searchQuery,
        ),
      ),
    );
  }

  void onOpenFile(OpenFileEvent event, Emitter<FileState> emit) async {
    final result = await openFileUseCase(params: event.file);
    result.fold(
      (failure) => emit(FilesErrorState(failure: failure)),
      (success) => null,
    );
  }
}
