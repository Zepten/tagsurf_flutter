import 'package:equatable/equatable.dart';

class ColorCodeEntity extends Equatable {
  final String? color;

  const ColorCodeEntity({required this.color});

  @override
  List<Object?> get props => [color];
}
