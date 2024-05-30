part of 'tag_bloc.dart';

abstract class TagEvent extends Equatable {}

// Tag events
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

// File-tag linking events
class GetTagsByFileEvent extends TagEvent {
  final FileEntity file;

  GetTagsByFileEvent({required this.file});

  @override
  List<Object?> get props => [file];
}

class LinkFileAndTagEvent extends TagEvent {
  final FileEntity file;
  final String tagName;

  LinkFileAndTagEvent({required this.file, required this.tagName});

  @override
  List<Object?> get props => [file, tagName];
}

class LinkOrCreateTagEvent extends TagEvent {
  final FileEntity file;
  final String tagName;

  LinkOrCreateTagEvent({required this.file, required this.tagName});

  @override
  List<Object?> get props => [file, tagName];
}

class UnlinkFileAndTagEvent extends TagEvent {
  final FileEntity file;
  final String tagName;

  UnlinkFileAndTagEvent({required this.file, required this.tagName});

  @override
  List<Object?> get props => [file, tagName];
}
