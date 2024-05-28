import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';

class TagDuplicateFailure extends Failure {
  final String tag;

  TagDuplicateFailure({required this.tag});

  @override
  List<Object?> get props => [tag];
}

class TagsDuplicateFailure extends Failure {
  final List<String> tags;

  TagsDuplicateFailure({required this.tags});

  @override
  List<Object?> get props => [tags];
}

class TagNotExistsFailure extends Failure {
  final String tag;

  TagNotExistsFailure({required this.tag});

  @override
  List<Object?> get props => [tag];
}

class TagsNotExistsFailure extends Failure {
  final List<String> tags;

  TagsNotExistsFailure({required this.tags});

  @override
  List<Object?> get props => [tags];
}

class InvalidTagFailure extends Failure {
  @override
  List<Object?> get props => List.empty();
}
