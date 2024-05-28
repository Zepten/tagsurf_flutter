import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';

class GetUnrackedFilesFromDirectoryUseCase
    implements UseCase<List<FileEntity>, String> {
  final FileRepository _fileRepository;

  GetUnrackedFilesFromDirectoryUseCase(this._fileRepository);

  @override
  Future<Either<Failure, List<FileEntity>>> call({required String params}) async {
    return await _fileRepository.getUntrackedFilesFromDirectory(targetDir: params);
  }
}
