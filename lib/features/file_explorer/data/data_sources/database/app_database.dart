import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/config/constants/app_database.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/DAO/file_dao.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/DAO/file_tags_dao.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/DAO/tag_dao.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/converters/color_converter.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/data_sources/database/converters/datetime_converter.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/file_tag_link.dart';
import 'package:tagsurf_flutter/features/file_explorer/data/models/tag.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

part 'app_database.g.dart';

@TypeConverters([DateTimeConverter, ColorConverter])
@Database(version: DATABASE_VERSION, entities: [FileModel, TagModel, FileTagLinkModel])
abstract class AppDatabase extends FloorDatabase {
  FileDao get fileDao;
  TagDao get tagDao;
  FileTagLinkDao get fileTagLinkDao;
}
