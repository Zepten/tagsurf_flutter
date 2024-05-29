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

  FileTagLinkDao? _fileTagLinkDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `files` (`path` TEXT NOT NULL, PRIMARY KEY (`path`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tags` (`name` TEXT NOT NULL, `parent_tag_name` TEXT, `color_code_red` INTEGER NOT NULL, `color_code_green` INTEGER NOT NULL, `color_code_blue` INTEGER NOT NULL, FOREIGN KEY (`parent_tag_name`) REFERENCES `tags` (`name`) ON UPDATE CASCADE ON DELETE SET NULL, PRIMARY KEY (`name`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `file_tag_link` (`file_path` TEXT NOT NULL, `tag_name` TEXT NOT NULL, FOREIGN KEY (`file_path`) REFERENCES `files` (`path`) ON UPDATE CASCADE ON DELETE CASCADE, FOREIGN KEY (`tag_name`) REFERENCES `tags` (`name`) ON UPDATE CASCADE ON DELETE CASCADE, PRIMARY KEY (`file_path`, `tag_name`))');
        await database
            .execute('CREATE INDEX `index_files_path` ON `files` (`path`)');
        await database
            .execute('CREATE INDEX `index_tags_name` ON `tags` (`name`)');
        await database.execute(
            'CREATE INDEX `index_tags_parent_tag_name` ON `tags` (`parent_tag_name`)');
        await database.execute(
            'CREATE INDEX `index_file_tag_link_file_path` ON `file_tag_link` (`file_path`)');
        await database.execute(
            'CREATE INDEX `index_file_tag_link_tag_name` ON `file_tag_link` (`tag_name`)');

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
  FileTagLinkDao get fileTagLinkDao {
    return _fileTagLinkDaoInstance ??=
        _$FileTagLinkDao(database, changeListener);
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
            FileModel(path: row['path'] as String));
  }

  @override
  Future<FileModel?> getFileByPath(String path) async {
    return _queryAdapter.query('select * from files where path = ?1',
        mapper: (Map<String, Object?> row) =>
            FileModel(path: row['path'] as String),
        arguments: [path]);
  }

  @override
  Future<List<FileModel>> getFilesByPaths(List<String> paths) async {
    const offset = 1;
    final _sqliteVariablesForPaths =
        Iterable<String>.generate(paths.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'select * from files where path in (' + _sqliteVariablesForPaths + ')',
        mapper: (Map<String, Object?> row) =>
            FileModel(path: row['path'] as String),
        arguments: [...paths]);
  }

  @override
  Future<void> insertFile(FileModel file) async {
    await _fileModelInsertionAdapter.insert(file, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertFiles(List<FileModel> files) async {
    await _fileModelInsertionAdapter.insertList(
        files, OnConflictStrategy.abort);
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
                  'name': item.name,
                  'parent_tag_name': item.parentTagName,
                  'color_code_red': item.colorCodeRed,
                  'color_code_green': item.colorCodeGreen,
                  'color_code_blue': item.colorCodeBlue
                }),
        _tagModelUpdateAdapter = UpdateAdapter(
            database,
            'tags',
            ['name'],
            (TagModel item) => <String, Object?>{
                  'name': item.name,
                  'parent_tag_name': item.parentTagName,
                  'color_code_red': item.colorCodeRed,
                  'color_code_green': item.colorCodeGreen,
                  'color_code_blue': item.colorCodeBlue
                }),
        _tagModelDeletionAdapter = DeletionAdapter(
            database,
            'tags',
            ['name'],
            (TagModel item) => <String, Object?>{
                  'name': item.name,
                  'parent_tag_name': item.parentTagName,
                  'color_code_red': item.colorCodeRed,
                  'color_code_green': item.colorCodeGreen,
                  'color_code_blue': item.colorCodeBlue
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
            name: row['name'] as String,
            parentTagName: row['parent_tag_name'] as String?,
            colorCodeRed: row['color_code_red'] as int,
            colorCodeGreen: row['color_code_green'] as int,
            colorCodeBlue: row['color_code_blue'] as int));
  }

  @override
  Future<TagModel?> getTagByName(String name) async {
    return _queryAdapter.query('select * from tags where name = ?1',
        mapper: (Map<String, Object?> row) => TagModel(
            name: row['name'] as String,
            parentTagName: row['parent_tag_name'] as String?,
            colorCodeRed: row['color_code_red'] as int,
            colorCodeGreen: row['color_code_green'] as int,
            colorCodeBlue: row['color_code_blue'] as int),
        arguments: [name]);
  }

  @override
  Future<List<TagModel>> getTagsByNames(List<String> names) async {
    const offset = 1;
    final _sqliteVariablesForNames =
        Iterable<String>.generate(names.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'select * from tags where name in (' + _sqliteVariablesForNames + ')',
        mapper: (Map<String, Object?> row) => TagModel(
            name: row['name'] as String,
            parentTagName: row['parent_tag_name'] as String?,
            colorCodeRed: row['color_code_red'] as int,
            colorCodeGreen: row['color_code_green'] as int,
            colorCodeBlue: row['color_code_blue'] as int),
        arguments: [...names]);
  }

  @override
  Future<List<TagModel>> getParentTags(String parentTagName) async {
    return _queryAdapter.queryList('select * from tags where name = ?1',
        mapper: (Map<String, Object?> row) => TagModel(
            name: row['name'] as String,
            parentTagName: row['parent_tag_name'] as String?,
            colorCodeRed: row['color_code_red'] as int,
            colorCodeGreen: row['color_code_green'] as int,
            colorCodeBlue: row['color_code_blue'] as int),
        arguments: [parentTagName]);
  }

  @override
  Future<void> insertTag(TagModel tag) async {
    await _tagModelInsertionAdapter.insert(tag, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertTags(List<TagModel> tags) async {
    await _tagModelInsertionAdapter.insertList(tags, OnConflictStrategy.abort);
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

class _$FileTagLinkDao extends FileTagLinkDao {
  _$FileTagLinkDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _fileTagLinkModelInsertionAdapter = InsertionAdapter(
            database,
            'file_tag_link',
            (FileTagLinkModel item) => <String, Object?>{
                  'file_path': item.filePath,
                  'tag_name': item.tagName
                }),
        _fileTagLinkModelDeletionAdapter = DeletionAdapter(
            database,
            'file_tag_link',
            ['file_path', 'tag_name'],
            (FileTagLinkModel item) => <String, Object?>{
                  'file_path': item.filePath,
                  'tag_name': item.tagName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FileTagLinkModel> _fileTagLinkModelInsertionAdapter;

  final DeletionAdapter<FileTagLinkModel> _fileTagLinkModelDeletionAdapter;

  @override
  Future<FileTagLinkModel?> getFileTagLink(
    String filePath,
    String tagName,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM file_tag_link WHERE file_path = ?1 AND tag_name = ?2',
        mapper: (Map<String, Object?> row) => FileTagLinkModel(
            filePath: row['file_path'] as String,
            tagName: row['tag_name'] as String),
        arguments: [filePath, tagName]);
  }

  @override
  Future<List<TagModel>> getTagsByFilePath(String filePath) async {
    return _queryAdapter.queryList(
        'SELECT t.* FROM tags t JOIN file_tag_link ft ON t.name = ft.tag_name JOIN files f ON ft.file_path = f.path WHERE f.path = ?1',
        mapper: (Map<String, Object?> row) => TagModel(name: row['name'] as String, parentTagName: row['parent_tag_name'] as String?, colorCodeRed: row['color_code_red'] as int, colorCodeGreen: row['color_code_green'] as int, colorCodeBlue: row['color_code_blue'] as int),
        arguments: [filePath]);
  }

  @override
  Future<List<FileModel>> getFilesByTagName(String tagName) async {
    return _queryAdapter.queryList(
        'SELECT f.* FROM files f JOIN file_tag_link ft ON f.path = ft.file_path JOIN tags t ON ft.tag_name = t.name WHERE t.name = ?1',
        mapper: (Map<String, Object?> row) => FileModel(path: row['path'] as String),
        arguments: [tagName]);
  }

  @override
  Future<List<FileModel>> getUntaggedFiles() async {
    return _queryAdapter.queryList(
        'SELECT f.* FROM files f LEFT JOIN file_tag_link ftl ON f.path = ftl.file_path WHERE ftl.file_path IS NULL',
        mapper: (Map<String, Object?> row) =>
            FileModel(path: row['path'] as String));
  }

  @override
  Future<void> insertFileTagLink(FileTagLinkModel fileTagLink) async {
    await _fileTagLinkModelInsertionAdapter.insert(
        fileTagLink, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertFileTagLinks(List<FileTagLinkModel> fileTagLinks) async {
    await _fileTagLinkModelInsertionAdapter.insertList(
        fileTagLinks, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteFileTagLink(FileTagLinkModel fileTagLink) async {
    await _fileTagLinkModelDeletionAdapter.delete(fileTagLink);
  }
}
