part of 'tag_bloc.dart';

abstract class TagEvent extends Equatable {}

class GetAllTagsEvent extends TagEvent {
  @override
  List<Object?> get props => List.empty();
}

class CreateTagsEvent extends TagEvent {
  final List<TagEntity> tags;

  CreateTagsEvent({required this.tags});

  @override
  List<Object?> get props => [tags];
}

class CreateTagEvent extends TagEvent {
  final TagEntity tag;

  CreateTagEvent({required this.tag});

  @override
  List<Object?> get props => [tag];
}

class UpdateTagEvent extends TagEvent {
  final TagEntity tag;

  UpdateTagEvent({required this.tag});

  @override
  List<Object?> get props => [tag];
}

class DeleteTagEvent extends TagEvent {
  final TagEntity tag;

  DeleteTagEvent({required this.tag});

  @override
  List<Object?> get props => [tag];
}
