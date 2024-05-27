import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/util/pick_file.dart';

AppBar appBar(BuildContext context) {
  return AppBar(
    title: const Text(
      'Tagsurf',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    centerTitle: false,
    actions: [
      // Кнопка обновления списка файлов и тегов
      IconButton(
        onPressed: () {
          context.read<FileBloc>().add(GetTrackedFilesEvent());
          context.read<TagBloc>().add(GetAllTagsEvent());
        },
        tooltip: 'Обновить',
        icon: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
      // Space between buttons
      const SizedBox(width: 20),
      // Кнопка поиска файла по названию или тегу
      IconButton(
          onPressed: () {},
          tooltip: 'Поиск',
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          )),
      IconButton(
        onPressed: () async => await pickFile(context),
        tooltip: 'Добавить файлы в Tagsurf',
        icon: const Icon(Icons.add_circle, color: Colors.white),
      ),
      IconButton(
        onPressed: () {},
        tooltip: 'Настройки',
        icon: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ),
    ],
  );
}
