import 'package:tagsurf_flutter/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/domain/repository/file_repository.dart';

class GetTrackedFileUseCase implements UseCase<List<FileEntity>, void> {
  final FileRepository _fileRepository;

  GetTrackedFileUseCase(this._fileRepository);

  @override
  Future<List<FileEntity>> call({void params}) {
    return _fileRepository.getTrackedFiles();
  }
}
