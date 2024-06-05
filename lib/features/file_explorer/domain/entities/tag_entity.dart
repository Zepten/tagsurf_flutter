import 'dart:ui';

import 'package:equatable/equatable.dart';

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

  @override
  List<Object?> get props => [name, parentTagName, color, dateTimeAdded];
}
