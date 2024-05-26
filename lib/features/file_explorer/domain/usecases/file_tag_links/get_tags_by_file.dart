import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_tag_link_repository.dart';

class GetTagsByFileUseCase implements UseCase<List<TagEntity>, FileEntity> {
  final FileTagLinkRepository _fileTagLinkRepository;

  GetTagsByFileUseCase(this._fileTagLinkRepository);

  @override
  Future<List<TagEntity>> call({required FileEntity params}) {
    return _fileTagLinkRepository.getTagsByFile(file: params);
  }
}
