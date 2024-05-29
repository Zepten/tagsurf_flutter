import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file_tag_link.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';

@dao
abstract class FileTagLinkDao {
  @Insert()
  Future<void> insertFileTagLink(FileTagLinkModel fileTagLink);

  @Insert()
  Future<void> insertFileTagLinks(List<FileTagLinkModel> fileTagLinks);

  @delete
  Future<void> deleteFileTagLink(FileTagLinkModel fileTagLink);

  @Query('SELECT * FROM file_tag_link WHERE file_path = :filePath AND tag_name = :tagName')
  Future<FileTagLinkModel?> getFileTagLink(String filePath, String tagName);

  @Query(
      'SELECT t.* FROM tags t JOIN file_tag_link ft ON t.name = ft.tag_name JOIN files f ON ft.file_path = f.path WHERE f.path = :filePath')
  Future<List<TagModel>> getTagsByFilePath(String filePath);

  @Query(
      'SELECT f.* FROM files f JOIN file_tag_link ft ON f.path = ft.file_path JOIN tags t ON ft.tag_name = t.name WHERE t.name = :tagName')
  Future<List<FileModel>> getFilesByTagName(String tagName);

  @Query(
      'SELECT f.* FROM files f LEFT JOIN file_tag_link ftl ON f.path = ftl.file_path WHERE ftl.file_path IS NULL')
  Future<List<FileModel>> getUntaggedFiles();
}
