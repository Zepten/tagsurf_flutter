class FileUtils {
  static String basename(String path) {
    return path.replaceAll('\\', '/').split('/').last;
  }
}
