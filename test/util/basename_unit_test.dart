import 'package:flutter_test/flutter_test.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/file_utils.dart';

void main() {
  test('Test basename utility method by backslash path', () {
    const path = '.\\testDir\\test\\1.txt';
    final basename = FileUtils.basename(path);
    expect(basename, equals('1.txt'));
  });

  test('Test basename utility method by slash path', () {
    const path = './testDir/test/1.txt';
    final basename = FileUtils.basename(path);
    expect(basename, equals('1.txt'));
  });
}
