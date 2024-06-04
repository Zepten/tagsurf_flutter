import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/exceptions.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/file_utils.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FileSystemServiceImpl implements FileSystemService {
  @override
  Future<List<FileModel>> getFilesFromDirectory(String targetDir) async {
    final files = Directory(targetDir)
        .listSync(recursive: true)
        .whereType<File>()
        .map((file) => FileModel(
              path: file.path,
              name: FileUtils.basename(file.path),
              dateTimeAdded: DateTime.now(),
            ))
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

  @override
  Future<void> openFile(FileModel file) async {
    final fileUri = Uri.file(file.path);

    if (await canLaunchUrl(fileUri)) {
      final filePath = fileUri.toFilePath(windows: Platform.isWindows);
      launchUrlString('file://$filePath', mode: LaunchMode.externalApplication);
    } else {
      throw FileOpeningException(filePath: file.path);
    }
  }
}
