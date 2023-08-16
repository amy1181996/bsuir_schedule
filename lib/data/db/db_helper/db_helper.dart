import 'dart:io';

import 'package:bsuir_schedule/data/db/db_helper/db_constants.dart';
import 'package:bsuir_schedule/data/db/model/base_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  static const String _dbName = 'main.db';
  static const int _dbVersion = 1;

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    _db ??= await init();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> init() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = documentDirectory.path + _dbName;
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await _createGroupTable(db);
    await _createLecturerTable(db);
  }

  _createGroupTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTableName.group} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        faculty_abbrev TEXT NOT NULL,
        speciality_name TEXT NOT NULL,
        speciality_abbrev TEXT NOT NULL,
        course INTEGER NOT NULL
      )
    ''');
  }

  _createLecturerTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTableName.lecturer} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        middle_name TEXT NOT NULL,
        photo_path TEXT NOT NULL,
        url_id TEXT
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> query(String table) async =>
      (await db).query(table);

  Future<int> insert(String table, BaseModel model) async =>
      (await db).insert(table, model.toMap());

  Future<int> update(String table, BaseModel model) async => (await db)
      .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  Future<int> delete(String table, BaseModel model) async =>
      (await db).delete(table, where: 'id = ?', whereArgs: [model.id]);
}
