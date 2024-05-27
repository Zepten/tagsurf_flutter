import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';

class CreateTagUseCase implements UseCase<void, TagEntity> {
  final TagRepository _tagRepository;

  CreateTagUseCase(this._tagRepository);

  @override
  Future<void> call({required TagEntity params}) {
    return _tagRepository.createTag(tag: params);
  }
}