// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  FileDao? _fileDaoInstance;

  TagDao? _tagDaoInstance;

  FilesTagsDao? _fileTagsDaoInstance;

  ColorCodeDao? _colorCodeDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `files` (`path` TEXT, PRIMARY KEY (`path`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tags` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `parent_tag_id` INTEGER, `color_code` TEXT NOT NULL, FOREIGN KEY (`parent_tag_id`) REFERENCES `TagEntity` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`color_code`) REFERENCES `ColorCodeEntity` (`color`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `color_codes` (`color` TEXT, PRIMARY KEY (`color`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `files_tags` (`file_path` TEXT, `tag_id` INTEGER, FOREIGN KEY (`file_path`) REFERENCES `FileEntity` (`path`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`tag_id`) REFERENCES `TagEntity` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`file_path`, `tag_id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FileDao get fileDao {
    return _fileDaoInstance ??= _$FileDao(database, changeListener);
  }

  @override
  TagDao get tagDao {
    return _tagDaoInstance ??= _$TagDao(database, changeListener);
  }

  @override
  FilesTagsDao get fileTagsDao {
    return _fileTagsDaoInstance ??= _$FilesTagsDao(database, changeListener);
  }

  @override
  ColorCodeDao get colorCodeDao {
    return _colorCodeDaoInstance ??= _$ColorCodeDao(database, changeListener);
  }
}

class _$FileDao extends FileDao {
  _$FileDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _fileModelInsertionAdapter = InsertionAdapter(database, 'files',
            (FileModel item) => <String, Object?>{'path': item.path}),
        _fileModelUpdateAdapter = UpdateAdapter(database, 'files', ['path'],
            (FileModel item) => <String, Object?>{'path': item.path}),
        _fileModelDeletionAdapter = DeletionAdapter(database, 'files', ['path'],
            (FileModel item) => <String, Object?>{'path': item.path});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FileModel> _fileModelInsertionAdapter;

  final UpdateAdapter<FileModel> _fileModelUpdateAdapter;

  final DeletionAdapter<FileModel> _fileModelDeletionAdapter;

  @override
  Future<List<FileModel>> getAllFiles() async {
    return _queryAdapter.queryList('select * from files',
        mapper: (Map<String, Object?> row) =>
            FileModel(path: row['path'] as String?));
  }

  @override
  Future<FileModel?> getFileByPath(String path) async {
    return _queryAdapter.query('select * from files where path = ?1',
        mapper: (Map<String, Object?> row) =>
            FileModel(path: row['path'] as String?),
        arguments: [path]);
  }

  @override
  Future<void> insertFile(FileModel file) async {
    await _fileModelInsertionAdapter.insert(file, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateFile(FileModel file) async {
    await _fileModelUpdateAdapter.update(file, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteFile(FileModel file) async {
    await _fileModelDeletionAdapter.delete(file);
  }
}

class _$TagDao extends TagDao {
  _$TagDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _tagModelInsertionAdapter = InsertionAdapter(
            database,
            'tags',
            (TagModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'parent_tag_id': item.parentTag,
                  'color_code': item.colorCode
                }),
        _tagModelUpdateAdapter = UpdateAdapter(
            database,
            'tags',
            ['id'],
            (TagModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'parent_tag_id': item.parentTag,
                  'color_code': item.colorCode
                }),
        _tagModelDeletionAdapter = DeletionAdapter(
            database,
            'tags',
            ['id'],
            (TagModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'parent_tag_id': item.parentTag,
                  'color_code': item.colorCode
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TagModel> _tagModelInsertionAdapter;

  final UpdateAdapter<TagModel> _tagModelUpdateAdapter;

  final DeletionAdapter<TagModel> _tagModelDeletionAdapter;

  @override
  Future<List<TagModel>> getAllTags() async {
    return _queryAdapter.queryList('select * from tags',
        mapper: (Map<String, Object?> row) => TagModel(
            id: row['id'] as int?,
            name: row['name'] as String?,
            parentTag: row['parent_tag_id'] as int?,
            colorCode: row['color_code'] as String));
  }

  @override
  Future<TagModel?> getTagById(int id) async {
    return _queryAdapter.query('select * from tags where id = ?1',
        mapper: (Map<String, Object?> row) => TagModel(
            id: row['id'] as int?,
            name: row['name'] as String?,
            parentTag: row['parent_tag_id'] as int?,
            colorCode: row['color_code'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertTag(TagModel tag) async {
    await _tagModelInsertionAdapter.insert(tag, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTag(TagModel tag) async {
    await _tagModelUpdateAdapter.update(tag, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTag(TagModel tag) async {
    await _tagModelDeletionAdapter.delete(tag);
  }
}

class _$FilesTagsDao extends FilesTagsDao {
  _$FilesTagsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _filesTagsModelInsertionAdapter = InsertionAdapter(
            database,
            'files_tags',
            (FilesTagsModel item) => <String, Object?>{
                  'file_path': item.filePath,
                  'tag_id': item.tagId
                }),
        _filesTagsModelUpdateAdapter = UpdateAdapter(
            database,
            'files_tags',
            ['file_path', 'tag_id'],
            (FilesTagsModel item) => <String, Object?>{
                  'file_path': item.filePath,
                  'tag_id': item.tagId
                }),
        _filesTagsModelDeletionAdapter = DeletionAdapter(
            database,
            'files_tags',
            ['file_path', 'tag_id'],
            (FilesTagsModel item) => <String, Object?>{
                  'file_path': item.filePath,
                  'tag_id': item.tagId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FilesTagsModel> _filesTagsModelInsertionAdapter;

  final UpdateAdapter<FilesTagsModel> _filesTagsModelUpdateAdapter;

  final DeletionAdapter<FilesTagsModel> _filesTagsModelDeletionAdapter;

  @override
  Future<List<int>> getTagsIdsByFilePath(String filePath) async {
    return _queryAdapter.queryList(
        'SELECT tag_id FROM files_tags WHERE file_path = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [filePath]);
  }

  @override
  Future<List<String>> getFilesPathsByTag(int tagId) async {
    return _queryAdapter.queryList(
        'SELECT file_path FROM files_tags WHERE tag_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        arguments: [tagId]);
  }

  @override
  Future<void> insertFileTags(FilesTagsModel filesTags) async {
    await _filesTagsModelInsertionAdapter.insert(
        filesTags, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateFileTags(FilesTagsModel filesTags) async {
    await _filesTagsModelUpdateAdapter.update(
        filesTags, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteFileTags(FilesTagsModel filesTags) async {
    await _filesTagsModelDeletionAdapter.delete(filesTags);
  }
}

class _$ColorCodeDao extends ColorCodeDao {
  _$ColorCodeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _colorCodeModelInsertionAdapter = InsertionAdapter(
            database,
            'color_codes',
            (ColorCodeModel item) => <String, Object?>{'color': item.color}),
        _colorCodeModelUpdateAdapter = UpdateAdapter(
            database,
            'color_codes',
            ['color'],
            (ColorCodeModel item) => <String, Object?>{'color': item.color}),
        _colorCodeModelDeletionAdapter = DeletionAdapter(
            database,
            'color_codes',
            ['color'],
            (ColorCodeModel item) => <String, Object?>{'color': item.color});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ColorCodeModel> _colorCodeModelInsertionAdapter;

  final UpdateAdapter<ColorCodeModel> _colorCodeModelUpdateAdapter;

  final DeletionAdapter<ColorCodeModel> _colorCodeModelDeletionAdapter;

  @override
  Future<List<ColorCodeModel>> getAllColorCodes() async {
    return _queryAdapter.queryList('select * from color_codes',
        mapper: (Map<String, Object?> row) =>
            ColorCodeModel(color: row['color'] as String?));
  }

  @override
  Future<void> insertColorCode(ColorCodeModel colorCode) async {
    await _colorCodeModelInsertionAdapter.insert(
        colorCode, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateColorCode(ColorCodeModel colorCode) async {
    await _colorCodeModelUpdateAdapter.update(
        colorCode, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteColorCode(ColorCodeModel colorCode) async {
    await _colorCodeModelDeletionAdapter.delete(colorCode);
  }
}
