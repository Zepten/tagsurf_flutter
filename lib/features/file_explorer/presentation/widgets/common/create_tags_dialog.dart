import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tagsurf_flutter/config/constants/color_codes.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

Future<List<TagEntity>?> showCreateTagsDialog(
    BuildContext context, List<TagEntity> existingTags) async {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController(text: '');
  final existingTagsNames = existingTags.map((tag) => tag.name).toList();
  Color pickedColor = defaultTagColor;
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) => AlertDialog(
      title: const Text('Создание тега'),
      content: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              validator: (value) {
                if (value == null) {
                  return null;
                }
                if (value.isEmpty) {
                  return 'Введите название тега';
                }
                if (value.trim().isEmpty) {
                  return 'Тег не может состоять из пробелов';
                }
                if (existingTagsNames.contains(value.trim())) {
                  return 'Такой тег уже существует';
                }
                return null;
              },
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Название тега",
              ),
            ),
            SizedBox(height: 16),
            BlockPicker(
              availableColors: availableTagColors,
              pickerColor: defaultTagColor,
              onColorChanged: (Color color) => pickedColor = color,
              layoutBuilder: (context, colors, child) => Row(
                children: [
                  for (Color color in colors) ...[
                    Expanded(child: child(color)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, null),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final tag = TagEntity(
                name: nameController.text,
                color: pickedColor,
                dateTimeAdded: DateTime.now(),
              );
              Navigator.pop(dialogContext, [tag]);
            }
          },
          child: const Text('Создать'),
        ),
      ],
    ),
  );
}
