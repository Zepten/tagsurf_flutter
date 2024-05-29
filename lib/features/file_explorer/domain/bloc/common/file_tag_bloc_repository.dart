import 'package:tagsurf_flutter/features/file_explorer/core/error/tags_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/file_and_tag_params.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/link_file_and_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/unlink_file_and_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/create_tag.dart';

class FileTagBlocRepository {
  // BLoCs
  final FileBloc _fileBloc;
  final TagBloc _tagBloc;

  // UseCases
  final CreateTagUseCase _createTagUseCase;
  final LinkFileAndTagUseCase _linkFileAndTagUseCase;
  final UnlinkFileAndTagUseCase _unlinkFileAndTagUseCase;

  FileTagBlocRepository(
      this._fileBloc,
      this._tagBloc,
      this._linkFileAndTagUseCase,
      this._unlinkFileAndTagUseCase,
      this._createTagUseCase);

  Future<void> linkFileAndTag(
      {required FileEntity file, required TagEntity tag}) async {
    final result = await _linkFileAndTagUseCase(
        params: FileAndTagParams(filePath: file.path, tagName: tag.name));
    result.fold(
      (failure) {
        print(failure);
      },
      (success) {
        _tagBloc.add(GetAllTagsEvent());
        _fileBloc.add(GetTrackedFilesEvent());
        _tagBloc.add(GetTagsByFileEvent(file: file));
      },
    );
  }

  Future<void> linkOrCreateTag(
      {required FileEntity file, required TagEntity tag}) async {
    final result = await _createTagUseCase(params: tag);
    result.fold(
      (failure) {
        if (failure is TagDuplicateFailure) {
          linkFileAndTag(file: file, tag: tag);
        } else {
          print(failure);
        }
      },
      (success) async {
        linkFileAndTag(file: file, tag: tag);
      },
    );
  }

  Future<void> unlinkFileAndTag(
      {required FileEntity file, required TagEntity tag}) async {
    final result = await _unlinkFileAndTagUseCase(
        params: FileAndTagParams(filePath: file.path, tagName: tag.name));
    result.fold(
      (failure) {
        print(failure);
      },
      (success) {
        _tagBloc.add(GetAllTagsEvent());
        _fileBloc.add(GetTrackedFilesEvent());
        _tagBloc.add(GetTagsByFileEvent(file: file));
      },
    );
  }
}
