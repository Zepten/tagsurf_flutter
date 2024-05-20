import 'dart:io';

class FileUtils {
  String basename(File file) {
    return file.path.split(Platform.pathSeparator).last;
  }
}
