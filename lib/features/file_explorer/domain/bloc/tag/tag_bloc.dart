import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/usecase/file_and_tag_params.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/get_tags_by_file.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/link_file_and_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/link_or_create_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/unlink_file_and_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/create_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/create_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/delete_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/get_all_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/update_tag.dart';

part 'tag_event.dart';
part 'tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  // Tag UseCases
  final GetAllTagsUseCase _getAllTagsUseCase;
  final CreateTagUseCase _createTagUseCase;
  final CreateTagsUseCase _createTagsUseCase;
  final UpdateTagUseCase _updateTagUseCase;
  final DeleteTagUseCase _deleteTagUseCase;
  // File-tag linking UseCases
  final GetTagsByFileUseCase _getTagsByFileUseCase;
  final LinkFileAndTagUseCase _linkFileAndTagUseCase;
  final LinkOrCreateTagUseCase _linkOrCreateTagUseCase;
  final UnlinkFileAndTagUseCase _unlinkFileAndTagUseCase;

  TagBloc(
      this._getAllTagsUseCase,
      this._createTagUseCase,
      this._deleteTagUseCase,
      this._createTagsUseCase,
      this._updateTagUseCase,
      this._getTagsByFileUseCase,
      this._linkFileAndTagUseCase,
      this._linkOrCreateTagUseCase,
      this._unlinkFileAndTagUseCase)
      : super(TagsLoadingState()) {
    // Tag events
    on<GetAllTagsEvent>(onGetAllTags);
    on<CreateTagEvent>(onCreateTag);
    on<CreateTagsEvent>(onCreateTags);
    on<UpdateTagEvent>(onUpdateTag);
    on<DeleteTagEvent>(onDeleteTag);

    // File-tag linking events
    on<GetTagsByFileEvent>(onGetTagsByFile);
    on<LinkFileAndTagEvent>(linkFileAndTag);
    on<LinkOrCreateTagEvent>(linkOrCreateTag);
    on<UnlinkFileAndTagEvent>(unlinkFileAndTag);
  }

  // Tag business logic
  void onGetAllTags(GetAllTagsEvent event, Emitter<TagState> emit) async {
    emit(TagsLoadingState());
    final tags = await _getAllTagsUseCase();
    tags.fold(
      (failure) => print(failure),
      (tags) => emit(TagsLoadedState(tags: tags)),
    );
  }

  void onCreateTag(CreateTagEvent event, Emitter<TagState> emit) async {
    emit(TagsLoadingState());
    await _createTagUseCase(params: event.tag);
    final tags = await _getAllTagsUseCase();
    tags.fold(
      (failure) => print(failure),
      (tags) => emit(TagsLoadedState(tags: tags)),
    );
  }

  void onCreateTags(CreateTagsEvent event, Emitter<TagState> emit) async {
    emit(TagsLoadingState());
    await _createTagsUseCase(params: event.tags);
    final tags = await _getAllTagsUseCase();
    tags.fold(
      (failure) => print(failure),
      (tags) => emit(TagsLoadedState(tags: tags)),
    );
  }

  void onUpdateTag(UpdateTagEvent event, Emitter<TagState> emit) async {
    emit(TagsLoadingState());
    await _updateTagUseCase(params: event.tag);
    final tags = await _getAllTagsUseCase();
    tags.fold(
      (failure) => print(failure),
      (tags) => emit(TagsLoadedState(tags: tags)),
    );
  }

  void onDeleteTag(DeleteTagEvent event, Emitter<TagState> emit) async {
    emit(TagsLoadingState());
    await _deleteTagUseCase(params: event.tag);
    final tags = await _getAllTagsUseCase();
    tags.fold(
      (failure) => print(failure),
      (tags) => emit(TagsLoadedState(tags: tags)),
    );
  }

  // File-tag linking business logic
  void onGetTagsByFile(GetTagsByFileEvent event, Emitter<TagState> emit) async {
    print('GetTagsByFileEvent for file: ${event.file}');
    emit(TagsForFileLoadingState(file: event.file));
    final tags = await _getTagsByFileUseCase(params: event.file);
    tags.fold(
      (failure) => print(failure),
      (tags) {
        emit(TagsForFileLoadedState(file: event.file, tags: tags));
      },
    );
  }

  void linkFileAndTag(LinkFileAndTagEvent event, Emitter<TagState> emit) async {
    final result = await _linkFileAndTagUseCase(
        params:
            FileAndTagParams(filePath: event.file.path, tagName: event.tagName));
    final tagsForFileResult = await _getTagsByFileUseCase(params: event.file);
    result.fold(
      (failure) {
        print(failure);
      },
      (success) {
        tagsForFileResult.fold(
          (getTagsFailure) => print(getTagsFailure),
          (tags) => emit(TagsForFileLoadedState(file: event.file, tags: tags)),
        );
      },
    );
  }

  void linkOrCreateTag(
      LinkOrCreateTagEvent event, Emitter<TagState> emit) async {
    emit(TagsLoadingState());
    final result = await _linkOrCreateTagUseCase(
        params: FileAndTagParams(
            filePath: event.file.path, tagName: event.tagName));
    final tagsForFileResult = await _getTagsByFileUseCase(params: event.file);
    final tagsResult = await _getAllTagsUseCase();
    result.fold(
      (failure) {
        print(failure);
      },
      (success) {
        tagsForFileResult.fold(
          (getTagsForFileFailure) => print(getTagsForFileFailure),
          (tagsForFile) {
            tagsResult.fold(
              (getTagsFailure) => print(getTagsFailure),
              (tags) {
                emit(TagsForFileLoadedState(file: event.file, tags: tagsForFile));
                emit(TagsLoadedState(tags: tags));
              },
            );
          },
        );
      },
    );
  }

  void unlinkFileAndTag(
      UnlinkFileAndTagEvent event, Emitter<TagState> emit) async {
    final result = await _unlinkFileAndTagUseCase(
        params:
            FileAndTagParams(filePath: event.file.path, tagName: event.tagName));
    final tagsForFileResult = await _getTagsByFileUseCase(params: event.file);
    result.fold(
      (failure) {
        print(failure);
      },
      (success) {
        tagsForFileResult.fold(
          (getTagsFailure) => print(getTagsFailure),
          (tags) => emit(TagsForFileLoadedState(file: event.file, tags: tags)),
        );
      },
    );
  }
}
