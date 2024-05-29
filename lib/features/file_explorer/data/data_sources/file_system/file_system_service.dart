import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';

abstract class FileSystemService {
  Future<List<FileModel>> getFilesFromDirectory(String targetDir);
  Future<bool> isFileExist(FileModel file);
  Future<List<String>> getNotExistFilesPaths(List<FileModel> files);
}

class FileSystemServiceImpl implements FileSystemService {
  @override
  Future<List<FileModel>> getFilesFromDirectory(String targetDir) async {
    final files = Directory(targetDir)
        .listSync(recursive: true)
        .whereType<File>()
        .map((file) => FileModel(path: file.path))
        .toList();
    return files;
  }

  @override
  Future<bool> isFileExist(FileModel file) async {
    return File(file.path).exists();
  }

  @override
  Future<List<String>> getNotExistFilesPaths(List<FileModel> files) async {
    final notExistFilePaths = files
        .filter((file) => !File(file.path).existsSync())
        .map((file) => file.path)
        .toList();
    return notExistFilePaths;
  }
}
