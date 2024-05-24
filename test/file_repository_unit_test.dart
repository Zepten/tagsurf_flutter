import 'package:flutter_test/flutter_test.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/file_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

Future<void> main() async {
  group('Track file', () {
    late AppDatabase database;
    late FileRepositoryImpl fileRepository;
    const emptyDir = 'D:\\GitGub\\tagsurf_flutter\\test\\test_files\\empty';
    const targetDir = 'D:\\GitGub\\tagsurf_flutter\\test\\test_files';

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
      fileRepository = FileRepositoryImpl(FileSystemServiceImpl(), database);
    });

    tearDown(() async {
      database.close();
    });

    // File system methods
    test('Empty directory', () async {
      final files = await fileRepository.getFilesFromDirectory(emptyDir);
      expect(files, isEmpty);
    });

    test('Directory with 5 text files', () async {
      final files = await fileRepository.getFilesFromDirectory(targetDir);
      expect(files, isNotEmpty);
      expect(files.length, 5);
    });

    // Database methods
    test('Track file', () async {
      const file = FileEntity(path: 'test track');

      await fileRepository.trackFile(file);
      final actual = await fileRepository.getTrackedFileByPath(file.path!);
      expect(actual, equals(file));
    });

    test('Untrack file', () async {
      const file = FileEntity(path: 'test untrack');

      await fileRepository.trackFile(file);
      final actual1 = await fileRepository.getTrackedFileByPath(file.path!);
      expect(actual1, equals(file));

      await fileRepository.untrackFile(file);
      final actual2 = await fileRepository.getTrackedFileByPath(file.path!);
      expect(actual2, isNull);
    });

    test('Track 2 files', () async {
      const file1 = FileEntity(path: 'test 1');
      const file2 = FileEntity(path: 'test 2');
      await fileRepository.trackFile(file1);
      await fileRepository.trackFile(file2);

      final actual1 = await fileRepository.getTrackedFiles();
      expect(actual1.length, 2);

      final actual2 = await fileRepository.getTrackedFileByPath(file1.path!);
      expect(actual2, equals(file1));

      final actual3 = await fileRepository.getTrackedFileByPath(file2.path!);
      expect(actual3, equals(file2));
    });

    test('Get untracked files from target directory with no files in DB',
        () async {
      const matchFiles = [
        FileEntity(
            path: 'D:\\GitGub\\tagsurf_flutter\\test\\test_files\\1.txt'),
        FileEntity(
            path: 'D:\\GitGub\\tagsurf_flutter\\test\\test_files\\2.txt'),
        FileEntity(
            path: 'D:\\GitGub\\tagsurf_flutter\\test\\test_files\\3.txt'),
        FileEntity(
            path:
                'D:\\GitGub\\tagsurf_flutter\\test\\test_files\\subdir\\4.txt'),
        FileEntity(
            path:
                'D:\\GitGub\\tagsurf_flutter\\test\\test_files\\subdir\\5.txt')
      ];
      final actual =
          await fileRepository.getUntrackedFilesFromDirectory(targetDir);
      expect(actual, equals(matchFiles));
    });

    test('Get untracked files from target directory with 2 files in DB',
        () async {
      const matchFiles = [
        FileEntity(
            path: 'D:\\GitGub\\tagsurf_flutter\\test\\test_files\\3.txt'),
        FileEntity(
            path:
                'D:\\GitGub\\tagsurf_flutter\\test\\test_files\\subdir\\4.txt'),
        FileEntity(
            path:
                'D:\\GitGub\\tagsurf_flutter\\test\\test_files\\subdir\\5.txt')
      ];

      fileRepository.trackFile(const FileEntity(
          path: 'D:\\GitGub\\tagsurf_flutter\\test\\test_files\\1.txt'));
      fileRepository.trackFile(const FileEntity(
          path: 'D:\\GitGub\\tagsurf_flutter\\test\\test_files\\2.txt'));

      final actual =
          await fileRepository.getUntrackedFilesFromDirectory(targetDir);

      expect(actual, equals(matchFiles));
    });
  });
}
