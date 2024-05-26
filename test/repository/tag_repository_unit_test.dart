import 'package:flutter_test/flutter_test.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/tag_repository_impl.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/color_code.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

Future<void> main() async {
  group('Test tag repository', () {
    late AppDatabase database;
    late TagRepositoryImpl tagRepository;

    setUp(() async {
      // Database and tag repository initialization
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
      tagRepository = TagRepositoryImpl(database);
    });

    tearDown(() async {
      database.close();
    });

    test('Create tag', () async {
      const tag = TagEntity(
          name: 'test tag',
          parentTagName: null,
          colorCode: ColorCode(red: 255, green: 255, blue: 255));

      // Create tag
      await tagRepository.createTag(tag: tag);

      // Check if tag is created
      final actual = await tagRepository.getTagByName(name: tag.name);
      expect(actual, equals(tag));
    });

    test('Create multiple tags', () async {
      const tags = [
        TagEntity(
            name: 'test tag 1',
            parentTagName: null,
            colorCode: ColorCode(red: 255, green: 0, blue: 0)),
        TagEntity(
            name: 'test tag 2',
            parentTagName: null,
            colorCode: ColorCode(red: 0, green: 255, blue: 0)),
        TagEntity(
            name: 'test tag 3',
            parentTagName: null,
            colorCode: ColorCode(red: 0, green: 0, blue: 255))
      ];

      // Create tag
      await tagRepository.createTags(tags: tags);

      // Check if tag is created
      final actual = await tagRepository.getAllTags();
      expect(actual, equals(tags));
    });

    test('Update tag', () async {
      const tag = TagEntity(
          name: 'test tag',
          parentTagName: null,
          colorCode: ColorCode(red: 255, green: 255, blue: 255));

      // Create tag
      await tagRepository.createTag(tag: tag);
      final actualCreated = await tagRepository.getTagByName(name: tag.name);
      expect(actualCreated, equals(tag));

      // Update tag
      const tagUpdated = TagEntity(
          name: 'test tag',
          parentTagName: null,
          colorCode: ColorCode(red: 0, green: 0, blue: 0));
      await tagRepository.updateTag(tag: tagUpdated);

      // Check if tag is updated
      final actualUpdated =
          await tagRepository.getTagByName(name: tagUpdated.name);
      expect(actualUpdated, equals(tagUpdated));
    });

    test('Delete tag', () async {
      const tag = TagEntity(
          name: 'test tag',
          parentTagName: null,
          colorCode: ColorCode(red: 255, green: 255, blue: 255));

      // Create tag
      await tagRepository.createTag(tag: tag);
      final actualCreated = await tagRepository.getTagByName(name: tag.name);
      expect(actualCreated, equals(tag));

      // Delete tag
      await tagRepository.deleteTag(tag: tag);

      // Check if tag is deleted
      final actualDeleted = await tagRepository.getTagByName(name: tag.name);
      expect(actualDeleted, isNull);
    });

    test('Get all tags', () async {
      const tags = [
        TagEntity(
            name: 'test tag 1',
            parentTagName: null,
            colorCode: ColorCode(red: 255, green: 0, blue: 0)),
        TagEntity(
            name: 'test tag 2',
            parentTagName: null,
            colorCode: ColorCode(red: 0, green: 255, blue: 0)),
        TagEntity(
            name: 'test tag 3',
            parentTagName: null,
            colorCode: ColorCode(red: 0, green: 0, blue: 255)),
      ];

      // Create tags
      for (final tag in tags) {
        await tagRepository.createTag(tag: tag);
      }

      // Get all tags
      final actual = await tagRepository.getAllTags();

      // Check if returned tags are the same as test tags
      expect(actual, equals(tags));
    });

    test('Get parent tag', () async {
      const parentTag = TagEntity(
          name: 'test parent tag',
          parentTagName: null,
          colorCode: ColorCode(red: 255, green: 255, blue: 255));
      const childTag = TagEntity(
          name: 'test child tag',
          parentTagName: 'test parent tag',
          colorCode: ColorCode(red: 255, green: 255, blue: 255));

      // Create parent tag
      await tagRepository.createTag(tag: parentTag);

      // Check if parent tag is created
      final actualParentCreated =
          await tagRepository.getTagByName(name: 'test parent tag');
      expect(actualParentCreated, equals(parentTag));

      // Create child tag
      await tagRepository.createTag(tag: childTag);

      // Check if child tag is created
      final actualChildCreated =
          await tagRepository.getTagByName(name: 'test child tag');
      expect(actualChildCreated, equals(childTag));

      // Get parent tag of child tag
      final actualParents =
          await tagRepository.getParentTags(childTag: childTag);
      expect(actualParents, equals([parentTag]));

      // Get parent tag of parent tag
      final actualParentParents =
          await tagRepository.getParentTags(childTag: parentTag);
      expect(actualParentParents, isEmpty);
    });
  });
}
