import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_repository.dart';

class GetUnrackedFilesUseCase implements UseCase<List<FileEntity>, String> {
  final FileRepository _fileRepository;

  GetUnrackedFilesUseCase(this._fileRepository);

  @override
  Future<List<FileEntity>> call({String? params}) {
    return _fileRepository.getFilesFromDirectory(params!);
  }
}
