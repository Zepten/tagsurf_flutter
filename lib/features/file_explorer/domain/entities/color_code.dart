import 'package:equatable/equatable.dart';

class ColorCode extends Equatable {
  final int red;
  final int green;
  final int blue;

  const ColorCode({required this.red, required this.green, required this.blue});

  @override
  List<Object?> get props => [red, green, blue];
}
