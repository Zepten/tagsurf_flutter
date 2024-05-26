import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';

class GetAllFilesFromDirectoryUseCase
    implements UseCase<List<FileEntity>, String> {
  final FileRepository _fileRepository;

  GetAllFilesFromDirectoryUseCase(this._fileRepository);

  @override
  Future<List<FileEntity>> call({required String params}) {
    return _fileRepository.getAllFilesFromDirectory(targetDir: params);
  }
}
