import 'package:bsuir_schedule/data/db/db_helper/db_constants.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';

class LecturerDb {
  Future<List<Lecturer>> getAllLecturers(DatabaseHelper db) async {
    final maps = await db.query(DbTableName.lecturer);
    return maps.map((map) => GetLecturer.fromMap(map).toLecturer()).toList();
  }

  Future<int> insertLecturer(DatabaseHelper db, Lecturer lecturer) async {
    return await db.insert(
        DbTableName.lecturer, AddLecturer.fromLecturer(lecturer));
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
