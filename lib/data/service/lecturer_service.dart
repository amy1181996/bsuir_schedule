import 'package:bsuir_schedule/data/api/lecturer_api.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/lecturer_db.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';

class LecturerService {
  static final LecturerDb _lecturerDb = LecturerDb();
  static final LecturerApi _lecturerApi = LecturerApi();

  Future<List<Lecturer>> getAllLecturers(DatabaseHelper db) async {
    List<Lecturer> lecturers = await _lecturerDb.getAllLecturers(db);

    if (lecturers.isEmpty) {
      lecturers = await _lecturerApi.getAllLecturers() ?? [];
      await Future.wait(
          lecturers.map((e) => _lecturerDb.insertLecturer(db, e)));
    }

    return lecturers;
  }

  Future<Lecturer?> getLecturerById(DatabaseHelper db, int id) async {
    return await _lecturerDb.getLecturerById(db, id);
  }

  Future<Lecturer?> getLecturerByUrlId(DatabaseHelper db, String urlId) async {
    return await _lecturerDb.getLecturerByUrlId(db, urlId);
  }

  Future<int> addLecturer(DatabaseHelper db, Lecturer lecturer) async {
    return await _lecturerDb.insertLecturer(db, lecturer);
  }
}
