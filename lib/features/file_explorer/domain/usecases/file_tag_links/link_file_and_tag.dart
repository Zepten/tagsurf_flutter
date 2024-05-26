import 'package:tagsurf_flutter/features/file_explorer/core/usecase/file_and_tag_params.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_tag_link_repository.dart';

class LinkFileAndTagUseCase implements UseCase<void, FileAndTagParams> {
  final FileTagLinkRepository _fileTagLinkRepository;

  LinkFileAndTagUseCase(this._fileTagLinkRepository);

  @override
  Future<void> call({required FileAndTagParams params}) {
    return _fileTagLinkRepository.linkFileAndTag(file: params.file, tag: params.tag);
  }
}
