import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';

class TrackFilesUseCase implements UseCase<void, List<FileEntity>> {
  final FileRepository _fileRepository;

  TrackFilesUseCase(this._fileRepository);

  @override
  Future<void> call({List<FileEntity>? params}) {
    return _fileRepository.trackFiles(params!);
  }
}
