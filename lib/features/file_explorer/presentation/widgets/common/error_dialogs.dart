import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/files_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/filtering/filtering_modes.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/info_files_list_widget.dart';

void showErrorDialog(
  BuildContext context,
  Failure failure,
  FilteringModes filteringMode,
  List<String> filters,
  String searchQuery,
) {
  if (failure is FilesDuplicateFailure) {
    Future.delayed(
        Duration.zero,
        () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext dialogContext) => PopScope(
                canPop: true,
                onPopInvoked: (bool didPop) async {
                  if (didPop) {
                    context.read<FileBloc>().add(GetFilesEvent(
                          filteringMode: filteringMode,
                          filters: filters,
                          searchQuery: searchQuery,
                        ));
                    context.read<TagBloc>().add(GetAllTagsEvent());
                    return;
                  }
                },
                child: AlertDialog(
                  title: Text(
                      'Файлы (${failure.files.length}) уже отслеживаются:'),
                  content: SizedBox(
                    height: 300,
                    width: 600,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FilesInfoList(filesPaths: failure.files),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        return Navigator.pop(dialogContext);
                      },
                    ),
                  ],
                ),
              ),
            ));
  } else if (failure is FilesNotInFileSystemFailure) {
    // TODO: select replacements for not found files
    Future.delayed(
        Duration.zero,
        () => showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext dialogContext) => AlertDialog(
                title: const Text('Файлы не обнаружены в системе'),
                content: SizedBox(
                  height: 300,
                  width: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FilesInfoList(filesPaths: failure.files),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('Удалить файлы из Tagsurf'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Найти и заменить файлы'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              ),
            ));
  } else {
    Future.delayed(
        Duration.zero,
        () => showDialog(
              context: context,
              builder: (BuildContext dialogContext) => AlertDialog(
                title: const Text('Ошибка'),
                content: Text(failure.toString()),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              ),
            ));
  }
}
