import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/file_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/file_tag_link_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/tag_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

Future<void> main() async {
  group('Test file-tag associations (linking) repository', () {
    late AppDatabase database;
    late FileRepositoryImpl fileRepository;
    late TagRepositoryImpl tagRepository;
    late FileTagLinkRepositoryImpl fileTagLinkRepository;

    const testFilesDir = 'tagsurf_flutter_test_files';
    late Directory targetDir;
    late File testFile;
    late FileEntity testFileEntity;

    late TagEntity testTagEntity;

    setUp(() async {
      // Database initialization
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();

      // File repository initialization
      fileRepository = FileRepositoryImpl(FileSystemServiceImpl(), database);

      // Tag repository initialization
      tagRepository = TagRepositoryImpl(database);

      // File-tag associations repository initialization
      fileTagLinkRepository = FileTagLinkRepositoryImpl(database);

      // Test file creation
      targetDir = Directory('${Directory.systemTemp.path}\\$testFilesDir');
      if (!await targetDir.exists()) {
        await targetDir.create();
        debugPrint('Created test directory: ${targetDir.path}');
      }
      testFile = File('${targetDir.path}\\1.txt');
      if (!await testFile.exists()) {
        await testFile.create(recursive: true);
        debugPrint('Created test file: ${testFile.path}');
      }

      // Track test file
      testFileEntity = FileEntity(
        path: testFile.path,
        dateTimeAdded: DateTime.now(),
      );
      await fileRepository.trackFiles(files: [testFileEntity]);

      // Create and track test tag
      testTagEntity = TagEntity(
        name: 'test tag',
        color: Colors.white,
        dateTimeAdded: DateTime.now(),
      );
      await tagRepository.createTag(tag: testTagEntity);
    });

    tearDown(() async {
      database.close();
    });

    test('Link (associate) file and tag', () async {
      // Link file and tag
      await fileTagLinkRepository.linkFileAndTag(
        filePath: testFileEntity.path,
        tagName: testTagEntity.name,
      );

      // Check if file and tag are linked (from file)
      final filesResult = await fileTagLinkRepository.getFilesByTags(
        tagsNames: [testTagEntity.name],
        searchQuery: '',
      );
      filesResult.fold(
        (failure) => fail('Failure on getFilesByTags: $failure'),
        (files) => expect(files, equals([testFileEntity])),
      );

      // Check if file and tag are linked (from tag)
      final tagsResult = await fileTagLinkRepository.getTagsByFile(
        file: testFileEntity,
      );
      tagsResult.fold(
        (failure) => fail('Failure on getTagsByFile: $failure'),
        (tags) => expect(tags, equals([testTagEntity])),
      );
    });

    test('Unlink (disassociate) file and tag', () async {
      //? Link file and tag
      await fileTagLinkRepository.linkFileAndTag(
        filePath: testFileEntity.path,
        tagName: testTagEntity.name,
      );

      // Check if file and tag are linked (from file)
      final filesLinkResult = await fileTagLinkRepository.getFilesByTags(
        tagsNames: [testTagEntity.name],
        searchQuery: '',
      );
      filesLinkResult.fold(
        (failure) => fail('Failure on getFilesByTags in linking: $failure'),
        (files) => expect(files, equals([testFileEntity])),
      );

      // Check if file and tag are linked (from tag)
      final tagsLinkResult = await fileTagLinkRepository.getTagsByFile(
        file: testFileEntity,
      );
      tagsLinkResult.fold(
        (failure) => fail('Failure on getTagsByFile in linking: $failure'),
        (tags) => expect(tags, equals([testTagEntity])),
      );

      //? Unlink file and tag
      await fileTagLinkRepository.unlinkFileAndTag(
          filePath: testFileEntity.path, tagName: testTagEntity.name);

      // Check if file and tag are unlinked (from file)
      final filesUnlinkResult = await fileTagLinkRepository.getFilesByTags(
        tagsNames: [testTagEntity.name],
        searchQuery: '',
      );
      filesUnlinkResult.fold(
        (failure) => fail('Failure on getFilesByTags in unlinking: $failure'),
        (files) => expect(files, isEmpty),
      );

      // Check if file and tag are unlinked (from tag)
      final tagsUnlinkResult = await fileTagLinkRepository.getTagsByFile(
        file: testFileEntity,
      );
      tagsUnlinkResult.fold(
        (failure) => fail('Failure on getTagsByFile in unlinking: $failure'),
        (tags) => expect(tags, isEmpty),
      );
    });
  });
}
