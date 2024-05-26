import 'package:flutter_test/flutter_test.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/file_system/file_system_service.dart';
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
    late FileEntity testFile;
    late TagEntity testTag;

    setUp(() async {
      // Database initialization
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();

      // File repository initialization
      fileRepository = FileRepositoryImpl(FileSystemServiceImpl(), database);

      // Tag repository initialization
      tagRepository = TagRepositoryImpl(database);

      // File-tag associations repository initialization
      fileTagLinkRepository = FileTagLinkRepositoryImpl(database);

      // Create mock file
      testFile = const FileEntity(path: 'test path');
      await fileRepository.trackFile(testFile);

      // Check if file is created
      final actualFile = await fileRepository.getTrackedFileByPath(testFile.path);
      expect(actualFile, equals(testFile));

      // Create tag
      testTag = const TagEntity(
          name: 'test tag', parentTagName: null, colorCode: '#ffffff');
      await tagRepository.createTag(testTag);

      // Check if tag is created
      final actualTag = await tagRepository.getTagByName(testTag.name);
      expect(actualTag, equals(testTag));
    });

    tearDown(() async {
      database.close();
    });

    test('Link (associate) file and tag', () async {
      await fileTagLinkRepository.linkFileAndTag(testFile, testTag);

      final actualFiles = await fileTagLinkRepository.getFilesByTag(testTag);
      expect(actualFiles, equals([testFile]));

      final actualTags = await fileTagLinkRepository.getTagsByFile(testFile);
      expect(actualTags, equals([testTag]));
    });

    test('Unlink (disassociate) file and tag', () async {
      await fileTagLinkRepository.linkFileAndTag(testFile, testTag);

      final actualFilesLinked = await fileTagLinkRepository.getFilesByTag(testTag);
      expect(actualFilesLinked, equals([testFile]));

      final actualTagsLinked = await fileTagLinkRepository.getTagsByFile(testFile);
      expect(actualTagsLinked, equals([testTag]));

      await fileTagLinkRepository.unlinkFileAndTag(testFile, testTag);

      final actualFilesUnlinked = await fileTagLinkRepository.getFilesByTag(testTag);
      expect(actualFilesUnlinked, isEmpty);

      final actualTagsUnlinked = await fileTagLinkRepository.getTagsByFile(testFile);
      expect(actualTagsUnlinked, isEmpty);
    });
  });
}
