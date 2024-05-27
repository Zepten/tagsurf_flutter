import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/file_tag_links/get_tags_by_file.dart';
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

  TagBloc(
      this._getAllTagsUseCase,
      this._createTagUseCase,
      this._deleteTagUseCase,
      this._createTagsUseCase,
      this._updateTagUseCase,
      this._getTagsByFileUseCase)
      : super(TagsLoadingState()) {
    // Tag events
    on<GetAllTagsEvent>(onGetAllTags);
    on<CreateTagEvent>(onCreateTag);
    on<CreateTagsEvent>(onCreateTags);
    on<UpdateTagEvent>(onUpdateTag);
    on<DeleteTagEvent>(onDeleteTag);

    // File-tag linking events
    on<GetTagsByFileEvent>(onGetTagsByFile);
  }

  // Tag business logic
  void onGetAllTags(GetAllTagsEvent event, Emitter<TagState> emit) async {
    emit(TagsLoadingState());
    final tags = await _getAllTagsUseCase();
    emit(TagsLoadedState(tags: tags));
  }

  void onCreateTag(CreateTagEvent event, Emitter<TagState> emit) async {
    emit(TagsLoadingState());
    await _createTagUseCase(params: event.tag);
    final tags = await _getAllTagsUseCase();
    emit(TagsLoadedState(tags: tags));
  }

  void onCreateTags(CreateTagsEvent event, Emitter<TagState> emit) async {
    emit(TagsLoadingState());
    await _createTagsUseCase(params: event.tags);
    final tags = await _getAllTagsUseCase();
    emit(TagsLoadedState(tags: tags));
  }

  void onUpdateTag(UpdateTagEvent event, Emitter<TagState> emit) async {
    emit(TagsLoadingState());
    await _updateTagUseCase(params: event.tag);
    final tags = await _getAllTagsUseCase();
    emit(TagsLoadedState(tags: tags));
  }

  void onDeleteTag(DeleteTagEvent event, Emitter<TagState> emit) async {
    emit(TagsLoadingState());
    await _deleteTagUseCase(params: event.tag);
    final tags = await _getAllTagsUseCase();
    emit(TagsLoadedState(tags: tags));
  }

  // File-tag linking business logic
  void onGetTagsByFile(GetTagsByFileEvent event, Emitter<TagState> emit) async {
    emit(TagsForFileLoadingState());
    final tags = await _getTagsByFileUseCase(params: event.file);
    emit(TagsForFileLoadedState(file: event.file, tags: tags));
  }
}
