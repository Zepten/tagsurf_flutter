import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/files_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service_impl.dart';
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
    late List<FileEntity> testFilesEntities;

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
        File('${targetDir.path}\\folder 2\\folder 2.2\\8.txt'),
      ];
      for (final file in testFiles) {
        if (!await file.exists()) {
          await file.create(recursive: true);
          debugPrint('Created test file: ${file.path}');
        }
      }
      testFilesEntities = testFiles
          .map((file) => FileEntity(
                path: file.path,
                dateTimeAdded: DateTime.now(),
              ))
          .toList(growable: false);
    });

    tearDown(() async {
      database.close();
    });

    // File system methods
    test('Empty directory', () async {
      final result = await fileRepository.getAllFilesFromDirectory(
        targetDir: emptyDir.path,
      );
      result.fold(
        (failure) => fail('Failure: $failure'),
        (files) => expect(files, isEmpty),
      );
    });

    test('Directory with test files', () async {
      final result = await fileRepository.getAllFilesFromDirectory(
        targetDir: targetDir.path,
      );
      result.fold(
        (failure) => fail('Failure: $failure'),
        (filesFromDirectory) => expect(
          filesFromDirectory,
          equals(testFilesEntities),
        ),
      );
    });

    // Database methods
    test('Track not existing test file, expecting failure', () async {
      final file = FileEntity(
        path: 'not existing test track',
        dateTimeAdded: DateTime.now(),
      );

      // Track file
      await fileRepository.trackFiles(files: [file]);

      // Check if file is tracked
      final result = await fileRepository.getTrackedFileByPath(path: file.path);
      result.fold(
        (failure) => expect(failure, isA<FilesNotExistsFailure>()),
        (files) => fail('Expecting failure'),
      );
    });

    test('Track existing test files', () async {
      // Track files
      await fileRepository.trackFiles(files: testFilesEntities);

      // Check if file is tracked
      final result = await fileRepository.getTrackedFiles(searchQuery: '');
      result.fold(
        (failure) => fail('Failure: $failure'),
        (files) => expect(files, equals(testFilesEntities)),
      );
    });

    test('Track existing test files while files with same paths exists', () async {
      // Track files
      final resultOk = await fileRepository.trackFiles(files: testFilesEntities);

      // Check if file tracking is successful
      resultOk.fold(
        (failure) =>
            fail('Failure on file tracking (expecting success): $failure'),
        (success) => null,
      );

      // Check if file is tracked
      final result = await fileRepository.getTrackedFiles(searchQuery: '');
      result.fold(
        (failure) => fail('Failure: $failure'),
        (files) => expect(files, equals(testFilesEntities)),
      );

      // Track same files again
      final resultNotOk = await fileRepository.trackFiles(files: testFilesEntities);

      // Check if same tag creation is not successful
      resultNotOk.fold(
        (failure) => expect(failure, isA<FilesDuplicateFailure>()),
        (success) => fail('Expecting failure on same files tracking'),
      );
    });

    test('Untrack tracked test files', () async {
      // Track files
      await fileRepository.trackFiles(files: testFilesEntities);

      // Check if files are tracked
      final result1 = await fileRepository.getTrackedFiles(searchQuery: '');
      result1.fold(
        (failure) => fail('Failure on check if files are tracked: $failure'),
        (files) => expect(files, equals(testFilesEntities)),
      );

      // Untrack files
      await fileRepository.untrackFiles(files: testFilesEntities);

      // Check if file is untracked
      final result2 = await fileRepository.getTrackedFiles(searchQuery: '');
      result2.fold(
        (failure) => fail('Failure on check if files are untracked: $failure'),
        (files) => expect(files, isEmpty),
      );
    });

    test('Search tracked test files', () async {
      // Search result
      const searchQuery = '.txt';
      final searchResultFiles = [
        testFilesEntities[0],
        testFilesEntities[7],
      ];

      // Track files
      await fileRepository.trackFiles(files: testFilesEntities);

      // Check if files are tracked
      final result1 = await fileRepository.getTrackedFiles(searchQuery: '');
      result1.fold(
        (failure) => fail('Failure on check if files are tracked: $failure'),
        (files) => expect(files, equals(testFilesEntities)),
      );

      // Search files
      final result2 = await fileRepository.getTrackedFiles(
        searchQuery: searchQuery,
      );
      result2.fold(
        (failure) => fail('Failure on search files: $failure'),
        (files) => expect(files, equals(searchResultFiles)),
      );
    });
  });
}
