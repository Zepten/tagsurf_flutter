import 'package:floor/floor.dart';
import 'package:tagsurf_flutter/data/data_sources/database/DAO/file_dao.dart';
import 'package:tagsurf_flutter/data/models/file.dart';
import 'package:tagsurf_flutter/data/models/tag.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

part 'app_database.g.dart';

@Database(version: 1, entities: [FileModel, TagModel])
abstract class AppDatabase extends FloorDatabase {
  FileDao get fileDAO;
}
