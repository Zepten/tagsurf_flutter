import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/filtering/filtering_modes.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/dialogs/settings_dialog.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/util/pick_file.dart';

AppBar appBar(
  Function reloadLists,
  BuildContext context,
  FilteringModes filteringMode,
  List<String> filters,
  String searchQuery,
) {
  return AppBar(
    title: const Text(
      'Tagsurf',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    centerTitle: false,
    actions: [
      // Кнопка обновления списков файлов и тегов
      IconButton(
        onPressed: () {
          context.read<TagBloc>().add(GetAllTagsEvent());
          reloadLists();
        },
        tooltip: 'Обновить списки',
        icon: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
      // Space between buttons
      const SizedBox(width: 20),
      IconButton(
        onPressed: () async =>
            await pickFile(context, filteringMode, filters, searchQuery),
        tooltip: 'Добавить файлы в Tagsurf',
        icon: const Icon(Icons.add_circle, color: Colors.white),
      ),
      IconButton(
        onPressed: () async => await showSettingsDialog(context),
        tooltip: 'Настройки',
        icon: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ),
    ],
  );
}
