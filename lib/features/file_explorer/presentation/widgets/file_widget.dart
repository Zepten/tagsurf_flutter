import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/file_utils.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/file/file_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FileWidget extends StatelessWidget {
  final FileEntity? file;

  const FileWidget({super.key, this.file});

  _openFile(String filePath) async {
    final fileUri = Uri.file(filePath);

    if (await canLaunchUrl(fileUri)) {
      final filePath = fileUri.toFilePath(windows: Platform.isWindows);
      launchUrlString('file://$filePath', mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open file at path: $filePath'; // TODO: error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onDoubleTap: () => _openFile(file!.path!),
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
                    FileUtils.basename(file!.path!),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Расстояние между названием файла и его путем
                  const SizedBox(height: 2),
                  // Путь к файлу
                  Text(
                    file!.path!,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Кнопка удаления файла
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.blue),
              onPressed: () {
                context.read<FileBloc>().add(UntrackFileEvent(file!));
              },
            ),
          ],
        ),
      ),
    );
  }
}
