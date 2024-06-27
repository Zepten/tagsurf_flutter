import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';

class CreateTagsUseCase implements UseCase<void, List<TagEntity>> {
  final TagRepository tagRepository;

  CreateTagsUseCase(this.tagRepository);

  @override
  Future<Either<Failure, void>> call({required List<TagEntity> params}) async {
    return await tagRepository.createTags(tags: params);
  }
}
