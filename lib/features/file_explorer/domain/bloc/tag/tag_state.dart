part of 'tag_bloc.dart';

abstract class TagState extends Equatable {}

class TagsLoadingState extends TagState {
  @override
  List<Object?> get props => List.empty();
}

class TagsLoadedState extends TagState {
  final Either<Failure, List<TagEntity>> tags;

  TagsLoadedState({required this.tags});

  @override
  List<Object?> get props => [tags];
}

class TagsForFileLoadingState extends TagState {
  @override
  List<Object?> get props => List.empty();
}

class TagsForFileLoadedState extends TagState {
  final Either<Failure, FileEntity> file;
  final Either<Failure, List<TagEntity>> tags;

  TagsForFileLoadedState({required this.file, required this.tags});

  @override
  List<Object?> get props => [file, tags];
}
