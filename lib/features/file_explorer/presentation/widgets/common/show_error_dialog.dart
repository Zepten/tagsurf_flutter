import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/failure.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/files_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/file_utils.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';

void showErrorDialog(BuildContext context, Failure failure) {
  if (failure is FilesDuplicateFailure) {
    Future.delayed(
        Duration.zero,
        () => showDialog(
              context: context,
              builder: (BuildContext dialogContext) => PopScope(
                canPop: true,
                onPopInvoked: (bool didPop) async {
                  if (didPop) {
                    context.read<FileBloc>().add(GetTrackedFilesEvent());
                    context.read<TagBloc>().add(GetAllTagsEvent());
                    return;
                  }
                },
                child: AlertDialog(
                  title: const Text('Следующие файлы уже отслеживаются'),
                  content: SizedBox(
                    height: 300,
                    width: 600,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: failure.files.length,
                            itemBuilder: (_, index) => Container(
                              margin: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  // Иконка
                                  const Icon(
                                    Icons.insert_drive_file,
                                    size: 45.0,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Tooltip(
                                      message: failure.files[index],
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Название файла
                                          Text(
                                            FileUtils.basename(
                                                failure.files[index]),
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
                                            failure.files[index],
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
