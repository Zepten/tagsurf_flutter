import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

class ColorCodeEntity extends Equatable {
  @PrimaryKey()
  final String? color;

  const ColorCodeEntity({required this.color});

  @override
  List<Object?> get props => [color];
}
