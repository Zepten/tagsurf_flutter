import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';

class CreateTagsUseCase implements UseCase<void, List<TagEntity>> {
  final TagRepository _tagRepository;

  CreateTagsUseCase(this._tagRepository);

  @override
  Future<void> call({required List<TagEntity> params}) {
    return _tagRepository.createTags(tags: params);
  }
}
