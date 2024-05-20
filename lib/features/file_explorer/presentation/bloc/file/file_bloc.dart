import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/get_tracked_files.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {

  final GetTrackedFilesUseCase _getTrackedFilesUseCase;

  FileBloc(this._getTrackedFilesUseCase) : super(const FileLoadingState()) {
    on<GetFileEvent>(onGetFiles);
  }

  void onGetFiles(GetFileEvent event, Emitter<FileState> emit) async {
    final files = await _getTrackedFilesUseCase();
    emit(FileLoadedState(files));
  }
}
