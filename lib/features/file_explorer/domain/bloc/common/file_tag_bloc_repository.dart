import 'package:tagsurf_flutter/features/file_explorer/core/usecase/file_and_tag_params.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/link_file_and_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/unlink_file_and_tag.dart';

class FileTagBlocRepository {
  // BLoCs
  final FileBloc fileBloc;
  final TagBloc tagBloc;

  // UseCases
  final LinkFileAndTagUseCase _linkFileAndTagUseCase;
  final UnlinkFileAndTagUseCase _unlinkFileAndTagUseCase;

  FileTagBlocRepository(this.fileBloc, this.tagBloc, this._linkFileAndTagUseCase, this._unlinkFileAndTagUseCase);

  void linkFileAndTag({required FileEntity file, required TagEntity tag}) async {
    await _linkFileAndTagUseCase(params: FileAndTagParams(file: file, tag: tag));
    fileBloc.add(GetTrackedFilesEvent());
    tagBloc.add(GetAllTagsEvent());
  }

  void unlinkFileAndTag({required FileEntity file, required TagEntity tag}) async {
    await _unlinkFileAndTagUseCase(params: FileAndTagParams(file: file, tag: tag));
    fileBloc.add(GetTrackedFilesEvent());
    tagBloc.add(GetAllTagsEvent());
  }
}
