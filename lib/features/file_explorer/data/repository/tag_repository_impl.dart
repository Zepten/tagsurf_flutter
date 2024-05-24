import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/repository/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final AppDatabase _appDatabase;

  TagRepositoryImpl(this._appDatabase);

  @override
  Future<void> createTag(TagEntity tag) async {
    _appDatabase.tagDao.insertTag(TagModel.fromEntity(tag));
  }

  @override
  Future<void> updateTag(TagEntity tag) async {
    _appDatabase.tagDao.updateTag(TagModel.fromEntity(tag));
  }

  @override
  Future<void> deleteTag(TagEntity tag) async {
    _appDatabase.tagDao.deleteTag(TagModel.fromEntity(tag));
  }

  @override
  Future<List<TagEntity>> getAllTags() async {
    final tagsModels = await _appDatabase.tagDao.getAllTags();
    return tagsModels
        .map((tagModel) => TagEntity.fromModel(tagModel))
        .toList(growable: false);
  }

  @override
  Future<TagEntity?> getTagByName(String name) async {
    final tagModel = await _appDatabase.tagDao.getTagByName(name);
    return tagModel == null ? null : TagEntity.fromModel(tagModel);
  }
}
