import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';

class UpdateFileUseCase implements UseCase<void, FileEntity> {
  final FileRepository _fileRepository;

  UpdateFileUseCase(this._fileRepository);

  @override
  Future<Either<Failure, void>> call({required FileEntity params}) async {
    return await _fileRepository.updateFile(file: params);
  }
}
