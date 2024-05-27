import 'package:tagsurf_flutter/features/file_explorer/core/usecase/file_and_tag_params.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/link_file_and_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/unlink_file_and_tag.dart';

class FileTagBlocRepository {
  // BLoCs
  final FileBloc fileBloc;
  final TagBloc tagBloc;

  // UseCases
  final LinkFileAndTagUseCase _linkFileAndTagUseCase;
  final UnlinkFileAndTagUseCase _unlinkFileAndTagUseCase;

  FileTagBlocRepository(this.fileBloc, this.tagBloc,
      this._linkFileAndTagUseCase, this._unlinkFileAndTagUseCase);

  Future<void> linkFileAndTag(
      {required String filePath, required String tagName}) async {
    await _linkFileAndTagUseCase(
        params: FileAndTagParams(filePath: filePath, tagName: tagName));
    tagBloc.add(GetAllTagsEvent());
    fileBloc.add(GetTrackedFilesEvent());
  }

  Future<void> unlinkFileAndTag(
      {required String filePath, required String tagName}) async {
    await _unlinkFileAndTagUseCase(
        params: FileAndTagParams(filePath: filePath, tagName: tagName));
    tagBloc.add(GetAllTagsEvent());
    fileBloc.add(GetTrackedFilesEvent());
  }
}
