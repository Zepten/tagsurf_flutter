import 'dart:ui';

import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';

class ChangeTagColorUseCase
    implements UseCase<void, ChangeTagColorUseCaseParams> {
  final TagRepository _tagRepository;

  ChangeTagColorUseCase(this._tagRepository);

  @override
  Future<Either<Failure, void>> call({
    required ChangeTagColorUseCaseParams params,
  }) async {
    return await _tagRepository.changeTagColor(
      tag: params.tag,
      color: params.color,
    );
  }
}

class ChangeTagColorUseCaseParams {
  final TagEntity tag;
  final Color color;

  ChangeTagColorUseCaseParams({required this.tag, required this.color});
}
