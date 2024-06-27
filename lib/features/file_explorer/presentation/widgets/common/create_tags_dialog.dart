import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

Future<List<TagEntity>?> showCreateTagsDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) => AlertDialog(
      title: const Text('Создание тега'),
      content: SingleChildScrollView(
        child: TextButton(
          onPressed: () => Navigator.pop(dialogContext, null),
          child: const Text('TEST'),
        ),
      ),
    ),
  );
}
