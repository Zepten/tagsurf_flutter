import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/error/tags_failures.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/repository/tag_repository_impl.dart';
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

    test('Create 1 tag', () async {
      final testTag = TagEntity(
        name: 'test tag',
        parentTagName: null,
        color: Colors.red,
        dateTimeAdded: DateTime.now(),
      );

      // Create tag
      await tagRepository.createTags(tags: [testTag]);

      // Check if tag is created
      final result = await tagRepository.getTagByName(name: testTag.name);
      result.fold(
        (failure) => fail('Failure: $failure'),
        (tag) => expect(tag, equals(testTag)),
      );
    });

    test('Create 3 different tags', () async {
      final testTags = [
        TagEntity(
          name: 'test tag 1',
          parentTagName: null,
          color: Colors.red,
          dateTimeAdded: DateTime.now(),
        ),
        TagEntity(
          name: 'test tag 2',
          parentTagName: null,
          color: Colors.green,
          dateTimeAdded: DateTime.now(),
        ),
        TagEntity(
          name: 'test tag 3',
          parentTagName: null,
          color: Colors.blue,
          dateTimeAdded: DateTime.now(),
        ),
      ];

      // Create tag
      await tagRepository.createTags(tags: testTags);

      // Check if tag is created
      final tagsNames = testTags.map((tag) => tag.name).toList();
      final result = await tagRepository.getTagsByNames(names: tagsNames);
      result.fold(
        (failure) => fail('Failure: $failure'),
        (tags) => expect(tags, equals(testTags)),
      );
    });

    test('Delete tag', () async {
      final testTag = TagEntity(
        name: 'test tag',
        parentTagName: null,
        color: Colors.red,
        dateTimeAdded: DateTime.now(),
      );

      // Create tag
      await tagRepository.createTags(tags: [testTag]);
      final createResult = await tagRepository.getTagByName(name: testTag.name);
      createResult.fold(
        (failure) => fail('Failure: $failure'),
        (tag) => expect(tag, equals(testTag)),
      );

      // Delete tag
      await tagRepository.deleteTag(tag: testTag);

      // Check if tag is deleted
      final deleteResult = await tagRepository.getTagByName(name: testTag.name);
      deleteResult.fold(
        (failure) => expect(failure, isA<TagsNotExistsFailure>()),
        (tag) => fail('Expecting TagsNotExistsFailure'),
      );
    });

    test('Get all tags', () async {
      final testTags = [
        TagEntity(
          name: 'test tag 1',
          parentTagName: null,
          color: Colors.red,
          dateTimeAdded: DateTime.now(),
        ),
        TagEntity(
          name: 'test tag 2',
          parentTagName: null,
          color: Colors.green,
          dateTimeAdded: DateTime.now(),
        ),
        TagEntity(
          name: 'test tag 3',
          parentTagName: null,
          color: Colors.blue,
          dateTimeAdded: DateTime.now(),
        ),
      ];

      // Create tags
      await tagRepository.createTags(tags: testTags);

      // Get all tags
      final result = await tagRepository.getAllTags();

      // Check if returned tags are the same as test tags
      result.fold(
        (failure) => fail('Failure: $failure'),
        (tags) => expect(tags, equals(testTags)),
      );
    });

    test('Create tag while tag with same name exists', () async {
      final testTag = TagEntity(
        name: 'test tag',
        parentTagName: null,
        color: Colors.red,
        dateTimeAdded: DateTime.now(),
      );

      // Create tag
      final resultOk = await tagRepository.createTags(tags: [testTag]);

      // Check if tag creation is successful
      resultOk.fold(
        (failure) =>
            fail('Failure on tag creation (expecting success): $failure'),
        (success) => null,
      );

      // Check if tag is created
      final result = await tagRepository.getTagByName(name: testTag.name);
      result.fold(
        (failure) => fail('Failure: $failure'),
        (tag) => expect(tag, equals(testTag)),
      );

      // Create same tag again
      final resultNotOk = await tagRepository.createTags(tags: [testTag]);

      // Check if same tag creation is not successful
      resultNotOk.fold(
        (failure) => expect(failure, isA<TagsDuplicateFailure>()),
        (success) => fail('Expecting failure on same tag creation'),
      );
    });
  });
}
