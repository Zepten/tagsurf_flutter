import 'dart:io';

class FileUtils {
  static String basename(File file) {
    return file.path.split(Platform.pathSeparator).last;
  }
}
