part of 'tag_bloc.dart';

abstract class TagEvent extends Equatable {
  final TagEntity? tag;
  final List<TagEntity>? tags;

  const TagEvent({this.tag, this.tags});

  @override
  List<Object> get props => [];
}

class GetAllTagsEvent extends TagEvent {
  const GetAllTagsEvent();
}

class CreateTagsEvent extends TagEvent {
  const CreateTagsEvent(List<TagEntity> tags) : super(tags: tags);
}

class CreateTagEvent extends TagEvent {
  const CreateTagEvent(TagEntity tag) : super(tag: tag);
}

class UpdateTagEvent extends TagEvent {
  const UpdateTagEvent(TagEntity tag) : super(tag: tag);
}

class DeleteTagEvent extends TagEvent {
  const DeleteTagEvent(TagEntity tag) : super(tag: tag);
}