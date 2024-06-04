import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

Future<bool> showTagDeleteConfirmation(
  BuildContext context,
  TagEntity tag,
) async {
  return await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Внимание'),
        content: Text('Вы действительно хотите удалить тег "${tag.name}"?'),
        actions: [
          TextButton(
            child: const Text('Отмена'),
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
          ),
          TextButton(
            child: const Text('Удалить тег'),
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
