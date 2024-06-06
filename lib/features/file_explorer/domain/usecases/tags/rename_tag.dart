import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';

class RenameTagUseCase implements UseCase<void, RenameTagUseCaseParams> {
  final TagRepository tagRepository;

  RenameTagUseCase(this.tagRepository);

  @override
  Future<Either<Failure, void>> call({required RenameTagUseCaseParams params}) async {
    return await tagRepository.renameTag(tag: params.tag, newName: params.newName);
  }
}

class RenameTagUseCaseParams {
  final TagEntity tag;
  final String newName;

  RenameTagUseCaseParams({required this.tag, required this.newName});
}
