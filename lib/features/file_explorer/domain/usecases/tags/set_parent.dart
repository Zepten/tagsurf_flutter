import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';

class SetParentTagUseCase implements UseCase<void, SetParentTagUseCaseParams> {
  final TagRepository tagRepository;

  SetParentTagUseCase(this.tagRepository);

  @override
  Future<Either<Failure, void>> call({required SetParentTagUseCaseParams params}) async {
    return await tagRepository.setParentTag(
      tag: params.tag,
      parentTag: params.parentTag,
    );
  }
}

class SetParentTagUseCaseParams {
  final TagEntity tag;
  final TagEntity? parentTag;

  SetParentTagUseCaseParams({required this.tag, required this.parentTag});
}
