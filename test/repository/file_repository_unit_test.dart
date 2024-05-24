import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/file_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

Future<void> main() async {
  group('Test file repository', () {
    late AppDatabase database;
    late FileRepositoryImpl fileRepository;

    const testFilesDir = 'tagsurf_flutter_test_files';
    late Directory targetDir;
    late Directory emptyDir;
    late List<File> testFiles;
    late List<FileEntity> matchFilesEntities;

    setUp(() async {
      // Database and file repository initialization
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
      fileRepository = FileRepositoryImpl(FileSystemServiceImpl(), database);

      // Test files creation
      targetDir = Directory('${Directory.systemTemp.path}\\$testFilesDir');
      if (!await targetDir.exists()) {
        await targetDir.create();
        debugPrint('Created test directory: ${targetDir.path}');
      }
      emptyDir = Directory('${targetDir.path}\\empty');
      if (!await emptyDir.exists()) {
        await emptyDir.create();
        debugPrint('Created empty test directory: ${emptyDir.path}');
      }
      testFiles = [
        File('${targetDir.path}\\1.txt'),
        File('${targetDir.path}\\2.bat'),
        File('${targetDir.path}\\folder 1\\3.jpg'),
        File('${targetDir.path}\\folder 1\\4.json'),
        File('${targetDir.path}\\folder 1\\folder 1.1\\5.dart'),
        File('${targetDir.path}\\folder 1\\folder 1.2\\6.cpp'),
        File('${targetDir.path}\\folder 2\\folder 2.1\\7.docx'),
        File('${targetDir.path}\\folder 2\\folder 2.2\\8.html'),
      ];
      for (final file in testFiles) {
        if (!await file.exists()) {
          await file.create(recursive: true);
          debugPrint('Created test file: ${file.path}');
        }
      }
      matchFilesEntities = testFiles
          .map((file) => FileEntity(path: file.path))
          .toList(growable: false);
    });

    tearDown(() async {
      database.close();
    });

    // File system methods
    test('Empty directory', () async {
      final files = await fileRepository.getAllFilesFromDirectory(emptyDir.path);
      expect(files, isEmpty);
    });

    test('Directory with test files', () async {
      final filesFromDirectory =
          await fileRepository.getAllFilesFromDirectory(targetDir.path);
      expect(filesFromDirectory, equals(matchFilesEntities));
    });

    // Database methods
    test('Track mock file', () async {
      const file = FileEntity(path: 'test track');

      // Track file
      await fileRepository.trackFile(file);

      // Check if file is tracked
      final actual = await fileRepository.getTrackedFileByPath(file.path!);
      expect(actual, equals(file));
    });

    test('Untrack mock file', () async {
      const file = FileEntity(path: 'test untrack');

      // Track file
      await fileRepository.trackFile(file);

      // Check if file is tracked
      final actual1 = await fileRepository.getTrackedFileByPath(file.path!);
      expect(actual1, equals(file));

      // Untrack file
      await fileRepository.untrackFile(file);

      // Check if file is untracked
      final actual2 = await fileRepository.getTrackedFileByPath(file.path!);
      expect(actual2, isNull);
    });

    test('Track multiple mock files', () async {
      const files = [
        FileEntity(path: 'test 1'),
        FileEntity(path: 'test 2'),
        FileEntity(path: 'test 3')
      ];

      // Track files
      for (final file in files) {
        await fileRepository.trackFile(file);
      }

      // Check if files are tracked
      final actual = await fileRepository.getTrackedFiles();
      expect(actual, equals(files));
    });

    test('Get untracked files from target directory with no files in DB',
        () async {
      // Get untracked files from target directory
      final actual =
          await fileRepository.getUntrackedFilesFromDirectory(targetDir.path);

      // Check if untracked files are the same as test files
      expect(actual, equals(matchFilesEntities));
    });

    test('Get untracked files from target directory with multiple files in DB',
        () async {
      const trackedFiles = [1, 3, 5];
      final matchFilesUntracked = List.from(matchFilesEntities);

      // Track some files from test files and remove them from untracked match files
      for (final index in trackedFiles) {
        await fileRepository.trackFile(matchFilesEntities[index]);
        matchFilesUntracked.remove(matchFilesEntities[index]);
      }

      // Get untracked files from target directory
      final actual =
          await fileRepository.getUntrackedFilesFromDirectory(targetDir.path);

      // Check if returned untracked files are the same as untracked match files
      expect(actual, equals(matchFilesUntracked));
    });
  });
}
