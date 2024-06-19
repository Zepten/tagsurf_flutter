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
            'CREATE TABLE IF NOT EXISTS `files` (`path` TEXT NOT NULL, `name` TEXT NOT NULL, `date_time_added` INTEGER NOT NULL, PRIMARY KEY (`path`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tags` (`name` TEXT NOT NULL, `parent_tag_name` TEXT, `color` INTEGER NOT NULL, `date_time_added` INTEGER NOT NULL, FOREIGN KEY (`parent_tag_name`) REFERENCES `tags` (`name`) ON UPDATE CASCADE ON DELETE SET NULL, PRIMARY KEY (`name`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `file_tag_link` (`file_path` TEXT NOT NULL, `tag_name` TEXT NOT NULL, `date_time_added` INTEGER NOT NULL, FOREIGN KEY (`file_path`) REFERENCES `files` (`path`) ON UPDATE CASCADE ON DELETE CASCADE, FOREIGN KEY (`tag_name`) REFERENCES `tags` (`name`) ON UPDATE CASCADE ON DELETE CASCADE, PRIMARY KEY (`file_path`, `tag_name`))');
        await database
            .execute('CREATE INDEX `index_files_path` ON `files` (`path`)');
        await database
            .execute('CREATE INDEX `index_files_name` ON `files` (`name`)');
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
        _fileModelInsertionAdapter = InsertionAdapter(
            database,
            'files',
            (FileModel item) => <String, Object?>{
                  'path': item.path,
                  'name': item.name,
                  'date_time_added':
                      _dateTimeConverter.encode(item.dateTimeAdded)
                }),
        _fileModelDeletionAdapter = DeletionAdapter(
            database,
            'files',
            ['path'],
            (FileModel item) => <String, Object?>{
                  'path': item.path,
                  'name': item.name,
                  'date_time_added':
                      _dateTimeConverter.encode(item.dateTimeAdded)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FileModel> _fileModelInsertionAdapter;

  final DeletionAdapter<FileModel> _fileModelDeletionAdapter;

  @override
  Future<List<FileModel>> getAllFiles(String searchQuery) async {
    return _queryAdapter.queryList(
        'SELECT * FROM FILES WHERE name LIKE ?1 ORDER BY date_time_added DESC',
        mapper: (Map<String, Object?> row) => FileModel(
            path: row['path'] as String,
            name: row['name'] as String,
            dateTimeAdded:
                _dateTimeConverter.decode(row['date_time_added'] as int)),
        arguments: [searchQuery]);
  }

  @override
  Future<FileModel?> getFileByPath(String path) async {
    return _queryAdapter.query('SELECT * FROM FILES WHERE path = ?1',
        mapper: (Map<String, Object?> row) => FileModel(
            path: row['path'] as String,
            name: row['name'] as String,
            dateTimeAdded:
                _dateTimeConverter.decode(row['date_time_added'] as int)),
        arguments: [path]);
  }

  @override
  Future<List<FileModel>> getFilesByPaths(List<String> paths) async {
    const offset = 1;
    final _sqliteVariablesForPaths =
        Iterable<String>.generate(paths.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM FILES WHERE path IN (' + _sqliteVariablesForPaths + ')',
        mapper: (Map<String, Object?> row) => FileModel(
            path: row['path'] as String,
            name: row['name'] as String,
            dateTimeAdded:
                _dateTimeConverter.decode(row['date_time_added'] as int)),
        arguments: [...paths]);
  }

  @override
  Future<void> insertFiles(List<FileModel> files) async {
    await _fileModelInsertionAdapter.insertList(
        files, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteFiles(List<FileModel> files) async {
    await _fileModelDeletionAdapter.deleteList(files);
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
                  'color': _colorConverter.encode(item.color),
                  'date_time_added':
                      _dateTimeConverter.encode(item.dateTimeAdded)
                }),
        _tagModelDeletionAdapter = DeletionAdapter(
            database,
            'tags',
            ['name'],
            (TagModel item) => <String, Object?>{
                  'name': item.name,
                  'parent_tag_name': item.parentTagName,
                  'color': _colorConverter.encode(item.color),
                  'date_time_added':
                      _dateTimeConverter.encode(item.dateTimeAdded)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TagModel> _tagModelInsertionAdapter;

  final DeletionAdapter<TagModel> _tagModelDeletionAdapter;

  @override
  Future<void> renameTag(
    String oldName,
    String newName,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE tags SET name = ?2 WHERE name = ?1',
        arguments: [oldName, newName]);
  }

  @override
  Future<void> changeTagColor(
    String tagName,
    int colorValue,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE tags SET color = ?2 WHERE name = ?1',
        arguments: [tagName, colorValue]);
  }

  @override
  Future<void> setParentTag(
    String tagName,
    String parentTagName,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE tags SET parent_tag_name = ?2 WHERE name = ?1',
        arguments: [tagName, parentTagName]);
  }

  @override
  Future<void> removeParentTag(String tagName) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE tags SET parent_tag_name = NULL WHERE name = ?1',
        arguments: [tagName]);
  }

  @override
  Future<List<TagModel>> getAllTags() async {
    return _queryAdapter.queryList(
        'SELECT * FROM TAGS ORDER BY date_time_added ASC',
        mapper: (Map<String, Object?> row) => TagModel(
            name: row['name'] as String,
            parentTagName: row['parent_tag_name'] as String?,
            color: _colorConverter.decode(row['color'] as int),
            dateTimeAdded:
                _dateTimeConverter.decode(row['date_time_added'] as int)));
  }

  @override
  Future<TagModel?> getTagByName(String tagName) async {
    return _queryAdapter.query('SELECT * FROM TAGS WHERE name = ?1',
        mapper: (Map<String, Object?> row) => TagModel(
            name: row['name'] as String,
            parentTagName: row['parent_tag_name'] as String?,
            color: _colorConverter.decode(row['color'] as int),
            dateTimeAdded:
                _dateTimeConverter.decode(row['date_time_added'] as int)),
        arguments: [tagName]);
  }

  @override
  Future<List<TagModel>> getTagsByNames(List<String> tagsNames) async {
    const offset = 1;
    final _sqliteVariablesForTagsNames =
        Iterable<String>.generate(tagsNames.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM TAGS WHERE name IN (' +
            _sqliteVariablesForTagsNames +
            ')',
        mapper: (Map<String, Object?> row) => TagModel(
            name: row['name'] as String,
            parentTagName: row['parent_tag_name'] as String?,
            color: _colorConverter.decode(row['color'] as int),
            dateTimeAdded:
                _dateTimeConverter.decode(row['date_time_added'] as int)),
        arguments: [...tagsNames]);
  }

  @override
  Future<TagModel?> getParentByTagName(String tagName) async {
    return _queryAdapter.query(
        'SELECT parent.* FROM tags AS child JOIN tags AS parent ON child.parent_tag_name = parent.name WHERE child.name = ?1',
        mapper: (Map<String, Object?> row) => TagModel(name: row['name'] as String, parentTagName: row['parent_tag_name'] as String?, color: _colorConverter.decode(row['color'] as int), dateTimeAdded: _dateTimeConverter.decode(row['date_time_added'] as int)),
        arguments: [tagName]);
  }

  @override
  Future<void> insertTag(TagModel tag) async {
    await _tagModelInsertionAdapter.insert(tag, OnConflictStrategy.abort);
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
                  'tag_name': item.tagName,
                  'date_time_added':
                      _dateTimeConverter.encode(item.dateTimeAdded)
                }),
        _fileTagLinkModelDeletionAdapter = DeletionAdapter(
            database,
            'file_tag_link',
            ['file_path', 'tag_name'],
            (FileTagLinkModel item) => <String, Object?>{
                  'file_path': item.filePath,
                  'tag_name': item.tagName,
                  'date_time_added':
                      _dateTimeConverter.encode(item.dateTimeAdded)
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
            tagName: row['tag_name'] as String,
            dateTimeAdded:
                _dateTimeConverter.decode(row['date_time_added'] as int)),
        arguments: [filePath, tagName]);
  }

  @override
  Future<List<TagModel>> getTagsByFilePath(String filePath) async {
    return _queryAdapter.queryList(
        'SELECT t.* FROM tags t JOIN file_tag_link ft ON t.name = ft.tag_name JOIN files f ON ft.file_path = f.path WHERE f.path = ?1 ORDER BY ft.date_time_added ASC',
        mapper: (Map<String, Object?> row) => TagModel(name: row['name'] as String, parentTagName: row['parent_tag_name'] as String?, color: _colorConverter.decode(row['color'] as int), dateTimeAdded: _dateTimeConverter.decode(row['date_time_added'] as int)),
        arguments: [filePath]);
  }

  @override
  Future<List<FileModel>> getFilesByTagsNames(
    List<String> tagsNames,
    String searchQuery,
  ) async {
    const offset = 2;
    final _sqliteVariablesForTagsNames =
        Iterable<String>.generate(tagsNames.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT DISTINCT f.* FROM files f JOIN file_tag_link ft ON f.path = ft.file_path JOIN tags t ON ft.tag_name = t.name WHERE t.name IN (' +
            _sqliteVariablesForTagsNames +
            ') AND f.name LIKE ?1 ORDER BY f.date_time_added DESC',
        mapper: (Map<String, Object?> row) => FileModel(path: row['path'] as String, name: row['name'] as String, dateTimeAdded: _dateTimeConverter.decode(row['date_time_added'] as int)),
        arguments: [searchQuery, ...tagsNames]);
  }

  @override
  Future<List<FileModel>> getUntaggedFiles(String searchQuery) async {
    return _queryAdapter.queryList(
        'SELECT f.* FROM files f LEFT JOIN file_tag_link ftl ON f.path = ftl.file_path WHERE ftl.file_path IS NULL AND f.name LIKE ?1 ORDER BY f.date_time_added DESC',
        mapper: (Map<String, Object?> row) => FileModel(path: row['path'] as String, name: row['name'] as String, dateTimeAdded: _dateTimeConverter.decode(row['date_time_added'] as int)),
        arguments: [searchQuery]);
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

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _colorConverter = ColorConverter();
