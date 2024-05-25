import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/get_tracked_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/track_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/track_multiple_files.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/untrack_file.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  // UseCases
  final GetTrackedFilesUseCase _getTrackedFilesUseCase;
  final TrackFileUseCase _trackFileUseCase;
  final UntrackFileUseCase _untrackFileUseCase;
  final TrackFilesUseCase _trackMultipleFilesUseCase;

  FileBloc(this._getTrackedFilesUseCase, this._trackFileUseCase,
      this._untrackFileUseCase, this._trackMultipleFilesUseCase)
      : super(const FileLoadingState()) {
    on<GetTrackedFilesEvent>(onGetTrackedFiles);
    on<TrackFileEvent>(onTrackFile);
    on<UntrackFileEvent>(onUntrackFile);
    on<TrackFilesEvent>(onTrackFiles);
  }

  void onGetTrackedFiles(
      GetTrackedFilesEvent event, Emitter<FileState> emit) async {
    final files = await _getTrackedFilesUseCase();
    emit(FileLoadedState(files));
  }

  void onTrackFile(
      TrackFileEvent trackFileEvent, Emitter<FileState> emit) async {
    await _trackFileUseCase(params: trackFileEvent.file);
    final files = await _getTrackedFilesUseCase();
    emit(FileLoadedState(files));
  }

  void onTrackFiles(
      TrackFilesEvent trackFilesEvent, Emitter<FileState> emit) async {
    await _trackMultipleFilesUseCase(params: trackFilesEvent.files);
    final files = await _getTrackedFilesUseCase();
    emit(FileLoadedState(files));
  }

  void onUntrackFile(
      UntrackFileEvent untrackFileEvent, Emitter<FileState> emit) async {
    await _untrackFileUseCase(params: untrackFileEvent.file);
    final files = await _getTrackedFilesUseCase();
    emit(FileLoadedState(files));
  }
}
