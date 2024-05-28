import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';

class TrackFileUseCase implements UseCase<void, FileEntity> {
  final FileRepository _fileRepository;

  TrackFileUseCase(this._fileRepository);

  @override
  Future<Either<Failure, void>> call({required FileEntity params}) async {
    return await _fileRepository.trackFile(file: params);
  }
}
