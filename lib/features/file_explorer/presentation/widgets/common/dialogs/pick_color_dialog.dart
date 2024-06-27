import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tagsurf_flutter/config/constants/color_codes.dart';

Future<Color?> showPickColorDialog(
    BuildContext context, Color currentColor) async {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) => AlertDialog(
      title: const Text('Выберите цвет тега'),
      content: SingleChildScrollView(
        child: BlockPicker(
          availableColors: availableTagColors,
          pickerColor: currentColor,
          onColorChanged: (Color color) => Navigator.pop(dialogContext, color),
        ),
      ),
    ),
  );
}
