import 'package:tagsurf_flutter/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/domain/repository/file_repository.dart';

class UntrackFileUseCase implements UseCase<void, FileEntity> {
  final FileRepository _fileRepository;

  UntrackFileUseCase(this._fileRepository);

  @override
  Future<void> call({FileEntity ? params}) {
    return _fileRepository.untrackFile(params!);
  }
}
