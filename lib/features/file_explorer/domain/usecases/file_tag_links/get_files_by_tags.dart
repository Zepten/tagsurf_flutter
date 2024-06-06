import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_tag_link_repository.dart';

class GetFilesByTagsUseCase
    implements UseCase<List<FileEntity>, GetFilesByTagsUseCaseParams> {
  final FileTagLinkRepository fileTagLinkRepository;

  GetFilesByTagsUseCase(this.fileTagLinkRepository);

  @override
  Future<Either<Failure, List<FileEntity>>> call({
    required GetFilesByTagsUseCaseParams params,
  }) async {
    return await fileTagLinkRepository.getFilesByTags(
      tagsNames: params.tagsNames,
      searchQuery: params.searchQuery,
    );
  }
}

class GetFilesByTagsUseCaseParams {
  final List<String> tagsNames;
  final String searchQuery;

  GetFilesByTagsUseCaseParams({
    required this.tagsNames,
    required this.searchQuery,
  });
}
