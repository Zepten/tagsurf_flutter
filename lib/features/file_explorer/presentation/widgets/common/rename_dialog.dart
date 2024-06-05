import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

Future<String?> showRenameTagDialog(BuildContext context, TagEntity tag) async {
  final TextEditingController controller =
      TextEditingController(text: tag.name);
  return showDialog<String>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Переименовать тег'),
        content: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Новое имя тега",
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, null),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, controller.text);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
