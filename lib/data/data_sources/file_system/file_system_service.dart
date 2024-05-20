import 'dart:io';

abstract class FileSystemService {
  Future<List<File>> getFiles(Directory targetDir);
}

class FileSystemServiceImpl implements FileSystemService {
  @override
  Future<List<File>> getFiles(Directory targetDir) async {
    if (await targetDir.exists()) {
      final files =
          targetDir.listSync(recursive: true).whereType<File>().toList();
      return files;
    } else {
      return [];
    }
  }
}
