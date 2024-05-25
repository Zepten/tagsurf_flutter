part of 'tag_bloc.dart';

abstract class TagState extends Equatable {
  final List<TagEntity>? tags;

  const TagState({this.tags});

  @override
  List<Object> get props => [tags!];
}

final class TagLoadingState extends TagState {
  const TagLoadingState();
}

final class TagLoadedState extends TagState {
  const TagLoadedState(List<TagEntity> tags) : super(tags: tags);
}
