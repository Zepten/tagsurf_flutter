import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';

class OpenFileUseCase implements UseCase<void, FileEntity> {
  final FileRepository fileRepository;

  OpenFileUseCase(this.fileRepository);

  @override
  Future<Either<Failure, void>> call({required FileEntity params}) async {
    return await fileRepository.openFile(file: params);
  }
}
