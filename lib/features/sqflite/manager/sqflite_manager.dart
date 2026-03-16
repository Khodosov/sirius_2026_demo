import 'package:path/path.dart' show join;

import 'package:sqflite/sqflite.dart';

class SqfliteManager {
  static const _dbName = 'demo.db';
  static const _tableName = 'entries';

  Database? _db;

  bool get isReady => _db != null;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            string_value TEXT NOT NULL,
            number_value INTEGER NOT NULL
          )
        ''');
      },
    );

    print('[sqflite] Database opened: $path');
  }

  Future<void> insert({
    required String stringValue,
    required int numberValue,
  }) async {
    await _db?.insert(_tableName, {
      'string_value': stringValue,
      'number_value': numberValue,
    });
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    return await _db?.query(_tableName) ?? [];
  }

  Future<List<Map<String, dynamic>>> getStringsOnly() async {
    return await _db?.query(
          _tableName,
          columns: ['id', 'string_value'],
        ) ??
        [];
  }

  Future<List<Map<String, dynamic>>> getNumbersOnly() async {
    return await _db?.query(
          _tableName,
          columns: ['id', 'number_value'],
        ) ??
        [];
  }

  Future<List<Map<String, dynamic>>> getWhereNumberGreaterThan(
    int threshold,
  ) async {
    return await _db?.query(
          _tableName,
          where: 'number_value > ?',
          whereArgs: [threshold],
        ) ??
        [];
  }

  Future<Map<String, dynamic>?> getSum() async {
    final result = await _db?.rawQuery(
      'SELECT COUNT(*) as count, SUM(number_value) as total FROM $_tableName',
    );
    return result?.firstOrNull;
  }

  Future<void> deleteAll() async {
    await _db?.delete(_tableName);
  }

  Future<void> dispose() async {
    await _db?.close();
    _db = null;
  }
}
