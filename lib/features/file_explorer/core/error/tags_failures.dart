import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

class TagsDuplicateFailure extends Failure {
  final List<String> tags;

  TagsDuplicateFailure({required this.tags});

  @override
  List<Object?> get props => [tags];
}

class TagsNotExistsFailure extends Failure {
  final List<String> tags;

  TagsNotExistsFailure({required this.tags});

  @override
  List<Object?> get props => [tags];
}

class InvalidTagFailure extends Failure {
  final TagEntity tag;

  InvalidTagFailure({required this.tag});

  @override
  List<Object?> get props => [];
}

class TagsCyclicDependencyFailure extends Failure {
  final List<TagEntity> tags;

  TagsCyclicDependencyFailure({required this.tags});

  @override
  List<Object?> get props => [tags];
}
