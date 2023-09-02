import 'package:bsuir_schedule/data/db/db_helper/db_constants.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:sqflite/sqflite.dart';

class LecturerDb {
  Future<List<Lecturer>> getAllLecturers(DatabaseHelper db) async {
    final maps = await db.query(DbTableName.lecturer);
    return maps.map((map) => GetLecturer.fromMap(map).toLecturer()).toList();
  }

  Future<Lecturer?> getLecturerById(DatabaseHelper db, int id) async {
    final maps =
        (await db.queryWhere(DbTableName.lecturer, 'id = ?', [id])).firstOrNull;

    if (maps == null) {
      return null;
    }

    return GetLecturer.fromMap(maps).toLecturer();
  }

  Future<Lecturer?> getLecturerByUrlId(DatabaseHelper db, String urlId) async {
    final maps =
        (await db.queryWhere(DbTableName.lecturer, 'url_id = ?', [urlId]))
            .firstOrNull;

    if (maps == null) {
      return null;
    }

    return GetLecturer.fromMap(maps).toLecturer();
  }

  Future<int> insertLecturer(DatabaseHelper db, Lecturer lecturer) async {
    try {
      return await db.insert(
          DbTableName.lecturer, AddLecturer.fromLecturer(lecturer));
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        return -1;
      }
      rethrow;
    }
  }

  Future<int> updateLecturer(DatabaseHelper db, Lecturer lecturer) async {
    return await db.update(
        DbTableName.lecturer, AddLecturer.fromLecturer(lecturer));
  }

  Future<int> deleteLecturer(DatabaseHelper db, Lecturer lecturer) async {
    return await db.delete(
        DbTableName.lecturer, AddLecturer.fromLecturer(lecturer));
  }
}
