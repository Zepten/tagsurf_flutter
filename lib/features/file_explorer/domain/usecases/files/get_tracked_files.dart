import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';

class GetTrackedFilesUseCase implements UseCase<List<FileEntity>, void> {
  final FileRepository _fileRepository;

  GetTrackedFilesUseCase(this._fileRepository);

  @override
  Future<List<FileEntity>> call({void params}) {
    return _fileRepository.getTrackedFiles();
  }
}
