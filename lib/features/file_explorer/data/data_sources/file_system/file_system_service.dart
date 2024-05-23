import 'dart:io';

import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';

abstract class FileSystemService {
  Future<List<FileModel>> getFilesFromDirectory(String targetDir);
}

class FileSystemServiceImpl implements FileSystemService {
  @override
  Future<List<FileModel>> getFilesFromDirectory(String targetDir) async {
    final directory = Directory(targetDir);
    if (!await directory.exists()) {
      // TODO: better error handling
      throw Exception('Directory does not exists.');
    }
    final files = directory
        .listSync(recursive: true)
        .whereType<File>()
        .map((file) => FileModel(path: file.path))
        .toList();
    return files;
  }
}
