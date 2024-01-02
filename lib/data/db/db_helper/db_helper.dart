import 'dart:io';

import 'package:bsuir_schedule/data/db/db_helper/db_constants.dart';
import 'package:bsuir_schedule/data/db/model/base_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  static const String _dbName = 'main.db';
  static const int _dbVersion = 46;

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
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  void _onCreate(Database db, int version) async {
    await _createGroupTable(db);
    await _createLecturerTable(db);
    await _createStarredGroupTable(db);
    await _createStarredLecturerTable(db);
    await _createLessonTable(db);
    await _createLessonGroupRelationTable(db);
    await _createLessonLecturerRelationTable(db);
    await _createGroupScheduleTable(db);
    await _createLecturerScheduleTable(db);
    await _createScheduleLastUpdateTable(db);
  }

  _createGroupTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTableName.group} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
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
        url_id TEXT NOT NULL UNIQUE
      )
    ''');
  }

  _createStarredGroupTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTableName.starredGroup} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_id INTEGER NOT NULL UNIQUE,
        FOREIGN KEY (group_id) REFERENCES ${DbTableName.group}(id)
      )
    ''');
  }

  _createStarredLecturerTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTableName.starredLecturer} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lecturer_id INTEGER NOT NULL UNIQUE,
        FOREIGN KEY (lecturer_id) REFERENCES ${DbTableName.lecturer}(id)
      )
    ''');
  }

  _createLessonTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTableName.lesson} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        auditories TEXT NOT NULL,
        start_lesson_time TEXT NOT NULL,
        end_lesson_time TEXT NOT NULL,
        lesson_type_abbrev TEXT NOT NULL,
        note TEXT,
        num_subgroup INTEGER NOT NULL,
        subject TEXT NOT NULL,
        subject_full_name TEXT NOT NULL,
        weeks TEXT NOT NULL,
        date_lesson TEXT,
        start_lesson_date TEXT,
        end_lesson_date TEXT,
        lesson_type INTEGER NOT NULL,
        weekday INTEGER,
        hash INTEGER NOT NULL UNIQUE
      )
    ''');
  }

  _createLessonGroupRelationTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTableName.lessonGroupRelation} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lesson_id INTEGER NOT NULL,
        group_id INTEGER NOT NULL,
        hash INTEGER NOT NULL UNIQUE,
        FOREIGN KEY (lesson_id) REFERENCES ${DbTableName.lesson}(id),
        FOREIGN KEY (group_id) REFERENCES ${DbTableName.group}(id)
      )
    ''');
  }

  _createLessonLecturerRelationTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTableName.lessonLecturerRelation} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lesson_id INTEGER NOT NULL,
        lecturer_id INTEGER NOT NULL,
        hash INTEGER NOT NULL UNIQUE,
        FOREIGN KEY (lesson_id) REFERENCES ${DbTableName.lesson}(id),
        FOREIGN KEY (lecturer_id) REFERENCES ${DbTableName.lecturer}(id)
      )
    ''');
  }

  _createGroupScheduleTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTableName.groupSchedule} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        start_exams_date TEXT,
        end_exams_date TEXT,
        group_id INTEGER UNIQUE,
        lecturer_id INTEGER,
        FOREIGN KEY (group_id) REFERENCES ${DbTableName.group}(id),
        FOREIGN KEY (lecturer_id) REFERENCES ${DbTableName.lecturer}(id)
      )
    ''');
  }

  _createLecturerScheduleTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTableName.lecturerSchedule} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        start_exams_date TEXT,
        end_exams_date TEXT,
        group_id INTEGER,
        lecturer_id INTEGER UNIQUE,
        FOREIGN KEY (group_id) REFERENCES ${DbTableName.group}(id),
        FOREIGN KEY (lecturer_id) REFERENCES ${DbTableName.lecturer}(id)
      )
    ''');
  }

  _createScheduleLastUpdateTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DbTableName.scheduleLastUpdate} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        schedule_id INTEGER NOT NULL UNIQUE,
        last_update TEXT NOT NULL,
        hash INTEGER NOT NULL UNIQUE,
        FOREIGN KEY (schedule_id) REFERENCES ${DbTableName.groupSchedule}(id)
      )
    ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS ${DbTableName.group}');
    await db.execute('DROP TABLE IF EXISTS ${DbTableName.lecturer}');
    await db.execute('DROP TABLE IF EXISTS ${DbTableName.starredGroup}');
    await db.execute('DROP TABLE IF EXISTS ${DbTableName.starredLecturer}');
    await db.execute('DROP TABLE IF EXISTS ${DbTableName.lesson}');
    await db.execute('DROP TABLE IF EXISTS ${DbTableName.lessonGroupRelation}');
    await db
        .execute('DROP TABLE IF EXISTS ${DbTableName.lessonLecturerRelation}');
    await db.execute('DROP TABLE IF EXISTS ${DbTableName.groupSchedule}');
    await db.execute('DROP TABLE IF EXISTS ${DbTableName.lecturerSchedule}');
    await db.execute('DROP TABLE IF EXISTS ${DbTableName.scheduleLastUpdate}');
    _onCreate(db, newVersion);
  }

  Future<List<Map<String, dynamic>>> query(String table) async =>
      (await db).query(table);

  Future<List<Map<String, dynamic>>> queryWhere(
          String table, String where, List<dynamic> whereArgs) async =>
      (await db).query(table, where: where, whereArgs: whereArgs);

  Future<int> insert(String table, BaseModel model) async =>
      (await db).insert(table, model.toMap());

  Future<int> update(String table, BaseModel model) async => (await db)
      .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  Future<int> updateWhere(String table, BaseModel model, String where,
          List<dynamic> whereArgs) async =>
      (await db)
          .update(table, model.toMap(), where: where, whereArgs: whereArgs);

  Future<int> delete(String table, BaseModel model) async =>
      (await db).delete(table, where: 'id = ?', whereArgs: [model.id]);

  Future<int> deleteWhere(
          String table, String where, List<dynamic> whereArgs) async =>
      (await db).delete(table, where: where, whereArgs: whereArgs);
}
