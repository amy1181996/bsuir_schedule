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
}
