import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service.dart';

void main() {
  final service = FileSystemServiceImpl();
  final emptyDir =
      Directory('D:\\ZLap\\GitHub\\tagsurf_flutter\\test\\test_files\\empty');
  final targetDir =
      Directory('D:\\ZLap\\GitHub\\tagsurf_flutter\\test\\test_files');
  test('Empty directory', () async {
    if (await emptyDir.exists()) {
      final files = await service.getFiles(emptyDir);
      expect(files, isEmpty);
    } else {
      throw Exception('Directory does not exist.');
    }
  });
  test('Directory with 3 text files', () async {
    if (await targetDir.exists()) {
      final files = await service.getFiles(targetDir);
      expect(files, isNotEmpty);
      expect(files.length, 3);
    } else {
      throw Exception('Directory does not exist.');
    }
  });
}
