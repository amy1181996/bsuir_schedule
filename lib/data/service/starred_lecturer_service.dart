import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/starred_lecturer_db.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';

class StarredLecturerService {
  static final StarredLecturerDb _starredLecturerDb = StarredLecturerDb();

  Future<List<Lecturer>> getAllStarredLecturers(DatabaseHelper db) async {
    return await _starredLecturerDb.getAllStarredLecturers(db);
  }

  Future<int> insertStarredLecturer(
      DatabaseHelper db, Lecturer lecturer) async {
    return await _starredLecturerDb.insertStarredLecturer(db, lecturer);
  }

  Future<int> deleteStarredLecturer(
      DatabaseHelper db, Lecturer lecturer) async {
    return await _starredLecturerDb.deleteStarredLecturer(db, lecturer);
  }
}
