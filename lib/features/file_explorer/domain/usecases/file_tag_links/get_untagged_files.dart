import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_tag_link_repository.dart';

class GetUntaggedFilesUseCase implements UseCase<List<FileEntity>, String> {
  final FileTagLinkRepository _fileTagLinkRepository;

  GetUntaggedFilesUseCase(this._fileTagLinkRepository);

  @override
  Future<Either<Failure, List<FileEntity>>> call({
    required String params,
  }) async {
    return await _fileTagLinkRepository.getUntaggedFiles(searchQuery: params);
  }
}
