part of 'tag_bloc.dart';

sealed class TagState extends Equatable {
  const TagState();
  
  @override
  List<Object> get props => [];
}

final class TagInitial extends TagState {}
