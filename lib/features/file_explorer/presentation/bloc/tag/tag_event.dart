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

class DeleteTagEvent extends TagEvent {
  final TagEntity tag;

  DeleteTagEvent({required this.tag});

  @override
  List<Object?> get props => [tag];
}

class SetParentTagEvent extends TagEvent {
  final TagEntity tag;
  final TagEntity? parentTag;

  SetParentTagEvent({required this.tag, required this.parentTag});

  @override
  List<Object?> get props => [tag, parentTag];
}

class RenameTagEvent extends TagEvent {
  final TagEntity tag;
  final String newName;

  RenameTagEvent({required this.tag, required this.newName});

  @override
  List<Object?> get props => [tag, newName];
}

class ChangeTagColorEvent extends TagEvent {
  final TagEntity tag;
  final Color color;

  ChangeTagColorEvent({required this.tag, required this.color});

  @override
  List<Object?> get props => [tag, color];
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
