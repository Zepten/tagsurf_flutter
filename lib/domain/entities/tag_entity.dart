import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/domain/entities/color_code_entity.dart';

class TagEntity extends Equatable {
  final int? id;
  final String? name;
  final ColorCodeEntity? colorCode;
  final TagEntity? parentTag;

  const TagEntity(
      {required this.id,
      required this.name,
      required this.colorCode,
      this.parentTag});

  @override
  List<Object?> get props => [id, name, colorCode, parentTag];
}
