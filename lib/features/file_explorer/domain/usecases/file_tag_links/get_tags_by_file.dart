import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_tag_link_repository.dart';

class GetTagsByFileUseCase implements UseCase<List<TagEntity>, FileEntity> {
  final FileTagLinkRepository fileTagLinkRepository;

  GetTagsByFileUseCase(this.fileTagLinkRepository);

  @override
  Future<Either<Failure, List<TagEntity>>> call({required FileEntity params}) async {
    return await fileTagLinkRepository.getTagsByFile(file: params);
  }
}
