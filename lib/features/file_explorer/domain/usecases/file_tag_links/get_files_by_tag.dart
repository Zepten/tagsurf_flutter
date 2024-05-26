import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_tag_link_repository.dart';

class GetFilesByTagUseCase implements UseCase<List<FileEntity>, TagEntity> {
  final FileTagLinkRepository _fileTagLinkRepository;

  GetFilesByTagUseCase(this._fileTagLinkRepository);

  @override
  Future<List<FileEntity>> call({required TagEntity params}) {
    return _fileTagLinkRepository.getFilesByTag(tag: params);
  }
}
