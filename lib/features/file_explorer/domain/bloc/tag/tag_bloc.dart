import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/create_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/create_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/delete_tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/get_all_tags.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/usecases/tags/update_tag.dart';

part 'tag_event.dart';
part 'tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  // UseCases
  final GetAllTagsUseCase _getAllTagsUseCase;
  final CreateTagUseCase _createTagUseCase;
  final CreateTagsUseCase _createTagsUseCase;
  final UpdateTagUseCase _updateTagUseCase;
  final DeleteTagUseCase _deleteTagUseCase;

  TagBloc(this._getAllTagsUseCase, this._createTagUseCase,
      this._deleteTagUseCase, this._createTagsUseCase, this._updateTagUseCase)
      : super(TagLoadingState()) {
    on<GetAllTagsEvent>(onGetAllTags);
    on<CreateTagEvent>(onCreateTag);
    on<CreateTagsEvent>(onCreateTags);
    on<UpdateTagEvent>(onUpdateTag);
    on<DeleteTagEvent>(onDeleteTag);
  }

  void onGetAllTags(GetAllTagsEvent event, Emitter<TagState> emit) async {
    final tags = await _getAllTagsUseCase();
    emit(TagLoadedState(tags: tags));
  }

  void onCreateTag(CreateTagEvent event, Emitter<TagState> emit) async {
    await _createTagUseCase(params: event.tag);
    final tags = await _getAllTagsUseCase();
    emit(TagLoadedState(tags: tags));
  }

  void onCreateTags(CreateTagsEvent event, Emitter<TagState> emit) async {
    await _createTagsUseCase(params: event.tags);
    final tags = await _getAllTagsUseCase();
    emit(TagLoadedState(tags: tags));
  }

  void onUpdateTag(UpdateTagEvent event, Emitter<TagState> emit) async {
    await _updateTagUseCase(params: event.tag);
    final tags = await _getAllTagsUseCase();
    emit(TagLoadedState(tags: tags));
  }

  void onDeleteTag(DeleteTagEvent event, Emitter<TagState> emit) async {
    await _deleteTagUseCase(params: event.tag);
    final tags = await _getAllTagsUseCase();
    emit(TagLoadedState(tags: tags));
  }
}
