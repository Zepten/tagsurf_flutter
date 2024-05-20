import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';

class UntrackFileUseCase implements UseCase<void, FileEntity> {
  final FileRepository _fileRepository;

  UntrackFileUseCase(this._fileRepository);

  @override
  Future<void> call({FileEntity ? params}) {
    return _fileRepository.untrackFile(params!);
  }
}