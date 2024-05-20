import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/domain/entities/tag_entity.dart';

class FileEntity extends Equatable {
  final int? id;
  final String? path;
  final List<TagEntity>? tags;

  const FileEntity({required this.id, required this.path, this.tags});

  @override
  List<Object?> get props => [id, path, tags];
}
