import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/file_and_tag_params.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/get_tags_by_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/link_file_and_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/link_or_create_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/unlink_file_and_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/change_tag_color.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/create_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/delete_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/get_all_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/rename_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/set_parent.dart';

part 'tag_event.dart';
part 'tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  // Tag UseCases
  final GetAllTagsUseCase getAllTagsUseCase;
  final CreateTagUseCase createTagUseCase;
  final RenameTagUseCase renameTagUseCase;
  final ChangeTagColorUseCase changeTagColorUseCase;
  final SetParentTagUseCase setParentTagUseCase;
  final DeleteTagUseCase deleteTagUseCase;
  // File-tag linking UseCases
  final GetTagsByFileUseCase getTagsByFileUseCase;
  final LinkFileAndTagUseCase linkFileAndTagUseCase;
  final LinkOrCreateTagUseCase linkOrCreateTagUseCase;
  final UnlinkFileAndTagUseCase unlinkFileAndTagUseCase;

  TagBloc(
      this.getAllTagsUseCase,
      this.createTagUseCase,
      this.deleteTagUseCase,
      this.renameTagUseCase,
      this.changeTagColorUseCase,
      this.getTagsByFileUseCase,
      this.linkFileAndTagUseCase,
      this.linkOrCreateTagUseCase,
      this.unlinkFileAndTagUseCase,
      this.setParentTagUseCase)
      : super(TagsLoadingState()) {
    // Tag events
    on<GetAllTagsEvent>(onGetAllTags);
    on<CreateTagEvent>(onCreateTag);
    on<RenameTagEvent>(onRenameTag);
    on<ChangeTagColorEvent>(onChangeTagColor);
    on<DeleteTagEvent>(onDeleteTag);
    on<SetParentTagEvent>(onSetParentTag);

    // File-tag linking events
    on<GetTagsByFileEvent>(onGetTagsByFile);
    on<LinkFileAndTagEvent>(linkFileAndTag);
    on<LinkOrCreateTagEvent>(linkOrCreateTag);
    on<UnlinkFileAndTagEvent>(unlinkFileAndTag);
  }

  // Tag business logic
  void onGetAllTags(GetAllTagsEvent event, Emitter<TagState> emit) async {
    emit(TagsLoadingState());
    final tags = await getAllTagsUseCase();
    print('GetAllTagsEvent, tags: $tags');
    tags.fold(
      (failure) => emit(TagsErrorState(failure: failure)),
      (tags) => emit(TagsLoadedState(tags: tags)),
    );
  }

  void onCreateTag(CreateTagEvent event, Emitter<TagState> emit) async {
    final result = await createTagUseCase(params: event.tag);
    result.fold(
      (failure) => emit(TagsErrorState(failure: failure)),
      (success) => add(GetAllTagsEvent()),
    );
  }

  void onRenameTag(RenameTagEvent event, Emitter<TagState> emit) async {
    final result = await renameTagUseCase(
      params: RenameTagUseCaseParams(
        tag: event.tag,
        newName: event.newName,
      ),
    );
    result.fold(
      (failure) => emit(TagsErrorState(failure: failure)),
      (success) => add(GetAllTagsEvent()),
    );
  }

  void onChangeTagColor(
    ChangeTagColorEvent event,
    Emitter<TagState> emit,
  ) async {
    final result = await changeTagColorUseCase(
      params: ChangeTagColorUseCaseParams(tag: event.tag, color: event.color),
    );
    result.fold(
      (failure) => emit(TagsErrorState(failure: failure)),
      (success) => add(GetAllTagsEvent()),
    );
  }

  void onSetParentTag(SetParentTagEvent event, Emitter<TagState> emit) async {
    final result = await setParentTagUseCase(
        params: SetParentTagUseCaseParams(
      tag: event.tag,
      parentTag: event.parentTag,
    ));
    result.fold(
      (failure) => emit(TagsErrorState(failure: failure)),
      (success) => add(GetAllTagsEvent()),
    );
  }

  void onDeleteTag(DeleteTagEvent event, Emitter<TagState> emit) async {
    final result = await deleteTagUseCase(params: event.tag);
    result.fold(
      (failure) => emit(TagsErrorState(failure: failure)),
      (success) => add(GetAllTagsEvent()),
    );
  }

  // File-tag linking business logic
  void onGetTagsByFile(
    GetTagsByFileEvent event,
    Emitter<TagState> emit,
  ) async {
    emit(TagsForFileLoadingState(file: event.file));
    final tags = await getTagsByFileUseCase(params: event.file);
    print('GetTagsByFileEvent: ${event.file.path} : $tags');
    tags.fold(
      (failure) => emit(TagsErrorState(failure: failure)),
      (tags) => emit(TagsForFileLoadedState(file: event.file, tags: tags)),
    );
  }

  void linkFileAndTag(
    LinkFileAndTagEvent event,
    Emitter<TagState> emit,
  ) async {
    final result = await linkFileAndTagUseCase(
      params: FileAndTagParams(
        filePath: event.file.path,
        tagName: event.tagName,
      ),
    );
    result.fold(
      (failure) => emit(TagsErrorState(failure: failure)),
      (success) => add(GetTagsByFileEvent(file: event.file)),
    );
  }

  void linkOrCreateTag(
    LinkOrCreateTagEvent event,
    Emitter<TagState> emit,
  ) async {
    final result = await linkOrCreateTagUseCase(
      params: FileAndTagParams(
        filePath: event.file.path,
        tagName: event.tagName,
      ),
    );
    result.fold(
      (failure) => emit(TagsErrorState(failure: failure)),
      (success) {
        add(GetTagsByFileEvent(file: event.file));
        add(GetAllTagsEvent());
      },
    );
  }

  void unlinkFileAndTag(
    UnlinkFileAndTagEvent event,
    Emitter<TagState> emit,
  ) async {
    final result = await unlinkFileAndTagUseCase(
      params: FileAndTagParams(
        filePath: event.file.path,
        tagName: event.tagName,
      ),
    );
    result.fold(
      (failure) => emit(TagsErrorState(failure: failure)),
      (success) => add(GetTagsByFileEvent(file: event.file)),
    );
  }
}
