import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/file_utils.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/files_list/file_tags_chips_widget.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/util/open_file.dart';

class FileWidget extends StatelessWidget {
  final FileEntity file;

  const FileWidget({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
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
                GestureDetector(
                  onTap: () {
                    // TODO: add filter or smth
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Название файла
                      Text(
                        FileUtils.basename(file.path),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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
                    ],
                  ),
                ),
                // Расстояние между информацией о файле и панелью тегов
                const SizedBox(height: 10),
                // Панель тегов файла
                FileTagsChipsWidget(file: file),
              ],
            ),
          ),
          // Кнопка открытия файла
          IconButton(
            icon: const Icon(Icons.open_in_new, color: Colors.blue),
            tooltip: 'Открыть файл',
            onPressed: () {
              openFile(file.path);
            },
          ),
          // Кнопка добавления в избранное
          IconButton(
            icon:
                const Icon(Icons.favorite_outline_sharp, color: Colors.blue),
            tooltip: 'Добавить в Избранное',
            onPressed: () {
              const AboutDialog();
            },
          ),
          // Кнопка удаления файла
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.blue),
            tooltip: 'Убрать файл',
            onPressed: () {
              context.read<FileBloc>().add(UntrackFileEvent(file: file));
            },
          ),
        ],
      ),
    );
  }
}
