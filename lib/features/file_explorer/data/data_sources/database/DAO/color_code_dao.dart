import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/color_code.dart';

@dao
abstract class ColorCodeDao {
  @Insert()
  Future<void> insertColorCode(ColorCodeModel colorCode);

  @delete
  Future<void> deleteColorCode(ColorCodeModel colorCode);

  @Query('select * from color_codes')
  Future<List<ColorCodeModel>> getAllColorCodes();
}