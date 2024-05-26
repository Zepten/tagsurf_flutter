import 'package:flutter_test/flutter_test.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/file_utils.dart';

void main() {
  test('Test basename utility method', () {
    const path = 'D:\\ZLap\\GitHub\\tagsurf_flutter\\test\\test_files\\1.txt';
    final basename = FileUtils.basename(path);
    expect(basename, equals('1.txt'));
  });
}
