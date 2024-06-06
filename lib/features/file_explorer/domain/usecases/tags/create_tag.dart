import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';

class CreateTagUseCase implements UseCase<void, TagEntity> {
  final TagRepository tagRepository;

  CreateTagUseCase(this.tagRepository);

  @override
  Future<Either<Failure, void>> call({required TagEntity params}) async {
    return await tagRepository.createTag(tag: params);
  }
}
