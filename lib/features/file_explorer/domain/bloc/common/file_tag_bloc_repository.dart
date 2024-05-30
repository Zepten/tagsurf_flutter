import 'package:tagsurf_flutter/features/file_explorer/core/usecase/file_and_tag_params.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/link_file_and_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/link_or_create_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/unlink_file_and_tag.dart';

class FileTagBlocRepository {
  // BLoCs
  final FileBloc _fileBloc;
  final TagBloc _tagBloc;

  // UseCases
  final LinkFileAndTagUseCase _linkFileAndTagUseCase;
  final LinkOrCreateTagUseCase _linkOrCreateTagUseCase;
  final UnlinkFileAndTagUseCase _unlinkFileAndTagUseCase;

  FileTagBlocRepository(
      this._fileBloc,
      this._tagBloc,
      this._linkFileAndTagUseCase,
      this._unlinkFileAndTagUseCase,
      this._linkOrCreateTagUseCase);

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
      },
    );
  }

  Future<void> linkOrCreateTag(
      {required FileEntity file, required String tagName}) async {
    final result = await _linkOrCreateTagUseCase(
        params: FileAndTagParams(filePath: file.path, tagName: tagName));
    result.fold(
      (failure) {
        print(failure);
      },
      (success) {
        _tagBloc.add(GetAllTagsEvent());
        _fileBloc.add(GetTrackedFilesEvent());
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
      },
    );
  }
}
