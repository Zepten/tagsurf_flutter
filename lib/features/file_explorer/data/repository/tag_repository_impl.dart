import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final AppDatabase _appDatabase;

  TagRepositoryImpl(this._appDatabase);

  @override
  Future<void> createTag({required TagEntity tag}) async {
    _appDatabase.tagDao.insertTag(TagModel.fromEntity(tag));
  }

  @override
  Future<void> createTags({required List<TagEntity> tags}) async {
    final tagsModels =
        tags.map((tagEntity) => TagModel.fromEntity(tagEntity)).toList();
    _appDatabase.tagDao.insertTags(tagsModels);
  }

  @override
  Future<void> updateTag({required TagEntity tag}) async {
    _appDatabase.tagDao.updateTag(TagModel.fromEntity(tag));
  }

  @override
  Future<void> deleteTag({required TagEntity tag}) async {
    _appDatabase.tagDao.deleteTag(TagModel.fromEntity(tag));
  }

  @override
  Future<List<TagEntity>> getAllTags() async {
    final tagsModels = await _appDatabase.tagDao.getAllTags();
    return tagsModels.map((tagModel) => TagEntity.fromModel(tagModel)).toList();
  }

  @override
  Future<TagEntity?> getTagByName({required String name}) async {
    final tagModel = await _appDatabase.tagDao.getTagByName(name);
    return tagModel == null ? null : TagEntity.fromModel(tagModel);
  }

  @override
  Future<List<TagEntity>> getParentTags({required TagEntity childTag}) async {
    if (childTag.parentTagName == null) {
      return [];
    } else {
      final tagsModels =
          await _appDatabase.tagDao.getParentTags(childTag.parentTagName!);
      return tagsModels
          .map((tagModel) => TagEntity.fromModel(tagModel))
          .toList();
    }
  }
}
