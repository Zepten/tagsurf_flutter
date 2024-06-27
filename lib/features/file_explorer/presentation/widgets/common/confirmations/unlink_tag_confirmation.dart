import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/file_utils.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

Future<bool> showTagUnlinkConfirmation(
  BuildContext context,
  TagEntity tag,
  FileEntity file,
) async {
  return await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Внимание'),
        content: Text(
            'Отвязать тег "${tag.name}" от файла "${FileUtils.basename(file.path)}"?'),
        actions: [
          TextButton(
            child: const Text('Отмена'),
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
          ),
          TextButton(
            child: const Text('Отвязать'),
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
