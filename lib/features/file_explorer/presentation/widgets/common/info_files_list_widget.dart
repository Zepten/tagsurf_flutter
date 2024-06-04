import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/file_utils.dart';

class FilesInfoList extends StatelessWidget {
  final List<String> filesPaths;

  const FilesInfoList({super.key, required this.filesPaths});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: filesPaths.length,
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
                  message: filesPaths[index],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Название файла
                      Text(
                        FileUtils.basename(filesPaths[index]),
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
                        filesPaths[index],
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
    );
  }
}
