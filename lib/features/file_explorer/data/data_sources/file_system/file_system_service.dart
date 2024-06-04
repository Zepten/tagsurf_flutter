import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';

abstract class FileSystemService {
  Future<List<FileModel>> getFilesFromDirectory(String targetDir);
  Future<bool> isFileExist(FileModel file);
  Future<List<String>> getNotExistFilesPaths(List<FileModel> files);
  Future<void> openFile(FileModel filePath);
}
