class FileSystemException implements Exception {
  final String message;

  const FileSystemException({required this.message});

  @override
  String toString() => message;
}

class DatabaseException implements Exception {
  final String message;

  const DatabaseException({required this.message});

  @override
  String toString() => message;
}

class FileOpeningException implements FileSystemException {
  final String filePath;

  const FileOpeningException({required this.filePath});

  @override
  String get message => 'Failed to open file: $filePath';
}
