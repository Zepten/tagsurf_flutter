import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/file_and_tag_params.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/usecase.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/file_tag_link_repository.dart';

class UnlinkFileAndTagUseCase implements UseCase<void, FileAndTagParams> {
  final FileTagLinkRepository _fileTagLinkRepository;

  UnlinkFileAndTagUseCase(this._fileTagLinkRepository);

  @override
  Future<Either<Failure, void>> call({required FileAndTagParams params}) async {
    return await _fileTagLinkRepository.unlinkFileAndTag(filePath: params.filePath, tagName: params.tagName);
  }
}
