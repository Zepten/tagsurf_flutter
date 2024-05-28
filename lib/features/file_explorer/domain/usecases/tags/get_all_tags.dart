import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';

class GetAllTagsUseCase implements UseCase<List<TagEntity>, void> {
  final TagRepository _tagRepository;

  GetAllTagsUseCase(this._tagRepository);

  @override
  Future<Either<Failure, List<TagEntity>>> call({void params}) async {
    return await _tagRepository.getAllTags();
  }
}
