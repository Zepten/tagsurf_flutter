part of 'tag_bloc.dart';

abstract class TagState extends Equatable {}

final class TagLoadingState extends TagState {
  @override
  List<Object?> get props => List.empty();
}

final class TagLoadedState extends TagState {
  final List<TagEntity> tags;

  TagLoadedState({required this.tags});

  @override
  List<Object?> get props => [tags];
}
