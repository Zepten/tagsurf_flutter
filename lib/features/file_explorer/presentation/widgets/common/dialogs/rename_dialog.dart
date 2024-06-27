import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

Future<String?> showRenameTagDialog(
    BuildContext context, TagEntity tag, List<String> existingTagsNames) async {
  final formKey = GlobalKey<FormState>();
  final TextEditingController controller =
      TextEditingController(text: tag.name);
  controller.selection =
      TextSelection(baseOffset: 0, extentOffset: controller.text.length);
  final currentName = tag.name;
  return showDialog<String>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Переименовать тег'),
        content: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: TextFormField(
            controller: controller,
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
              if (currentName != value.trim() &&
                  existingTagsNames.contains(value.trim())) {
                return 'Такой тег уже существует';
              }
              return null;
            },
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Новое имя тега",
            ),
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
                if (currentName != controller.text.trim()) {
                  Navigator.pop(dialogContext, controller.text);
                } else {
                  Navigator.pop(dialogContext, null);
                }
              }
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
