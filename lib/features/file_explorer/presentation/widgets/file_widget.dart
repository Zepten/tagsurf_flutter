import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/file_utils.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/color_code.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FileWidget extends StatelessWidget {
  final FileEntity file;

  const FileWidget({super.key, required this.file});

  _openFile(String filePath) async {
    final fileUri = Uri.file(filePath);

    if (await canLaunchUrl(fileUri)) {
      final filePath = fileUri.toFilePath(windows: Platform.isWindows);
      launchUrlString('file://$filePath', mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open file at path: $filePath'; // TODO: error message
    }
  }

  _buildTagChipList() {
    final tags = <TagEntity>[
      const TagEntity(
          name: 'Тестовый тег №1',
          colorCode: ColorCode(red: 255, green: 255, blue: 255)),
      const TagEntity(
          name: 'Тестовый тег №2',
          colorCode: ColorCode(red: 250, green: 220, blue: 255)),
      const TagEntity(
          name: 'Прикол',
          colorCode: ColorCode(red: 255, green: 230, blue: 255)),
      const TagEntity(
          name: 'Аниме', colorCode: ColorCode(red: 200, green: 255, blue: 220)),
      const TagEntity(
          name: 'Треш', colorCode: ColorCode(red: 255, green: 220, blue: 200)),
      const TagEntity(
          name: 'Программирование',
          colorCode: ColorCode(red: 255, green: 220, blue: 255)),
      const TagEntity(
          name: 'Test', colorCode: ColorCode(red: 230, green: 230, blue: 230)),
      const TagEntity(
          name: 'GitHub',
          colorCode: ColorCode(red: 240, green: 200, blue: 255)),
    ];
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: tags.map((TagEntity tag) {
        return Chip(
          label: Text(tag.name,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
          deleteButtonTooltipMessage: 'Убрать тег',
          onDeleted: () {
            // TODO: Обработка события удаления тега с файла
            // здесь, возможно, вам придется использовать setState или обращение к bloc,
            // чтобы управлять состоянием списка тегов и обновлять UI по необходимости.
          },
          deleteIcon:
              const Icon(Icons.remove_circle, color: Colors.black, size: 14),
          backgroundColor: Color.fromARGB(
              255, tag.colorCode.red, tag.colorCode.green, tag.colorCode.blue),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onDoubleTap: () => _openFile(file.path),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail placeholder
            const Icon(
              Icons.insert_drive_file,
              size: 45.0,
              color: Colors.blue,
            ),
            // Расстояние между thumbnail и информацией о файле
            const SizedBox(width: 10),
            // Информация о файле
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название файла
                  Text(
                    FileUtils.basename(file.path),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Расстояние между названием файла и его путем
                  const SizedBox(height: 2),
                  // Путь к файлу
                  Text(
                    file.path,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Расстояние между информацией о файле и панелью тегов
                  const SizedBox(height: 10),
                  _buildTagChipList(),
                ],
              ),
            ),
            // Кнопка удаления файла
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.blue),
              onPressed: () {
                context.read<FileBloc>().add(UntrackFileEvent(file: file));
              },
            ),
          ],
        ),
      ),
    );
  }
}
