import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';

class LinkNotExistFailure extends Failure {
  final String file;
  final String tag;

  LinkNotExistFailure({required this.file, required this.tag});

  @override
  List<Object?> get props => [file, tag];
}
