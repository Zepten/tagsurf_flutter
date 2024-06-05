import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:tagsurf_flutter/config/constants/color_codes.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';

class TagEntity extends Equatable {
  final String name;
  final String? parentTagName;
  final Color color;
  final DateTime dateTimeAdded;

  const TagEntity({
    required this.name,
    this.parentTagName,
    required this.color,
    required this.dateTimeAdded,
  });

  factory TagEntity.fromModel(TagModel tagModel) {
    return TagEntity(
      name: tagModel.name,
      parentTagName: tagModel.parentTagName,
      color: tagModel.color,
      dateTimeAdded: tagModel.dateTimeAdded,
    );
  }

  factory TagEntity.fromDefaults(String name) {
    return TagEntity(
      name: name,
      color: defaultTagColor,
      dateTimeAdded: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [name, parentTagName, color, dateTimeAdded];
}
