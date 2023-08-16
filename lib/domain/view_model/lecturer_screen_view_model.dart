import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/service/lecturer_service.dart';
import 'package:bsuir_schedule/data/service/starred_lecturer_service.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:flutter/foundation.dart';

class LecturerScreenViewModel extends ChangeNotifier {
  List<Lecturer> _lecturers = [];
  List<Lecturer> _starredLecturers = [];
  static final LecturerService _lecturerService = LecturerService();
  static final StarredLecturerService _starredLecturerService =
      StarredLecturerService();

  List<Lecturer> get lecturers => _lecturers;
  List<Lecturer> get starredLecturers => _starredLecturers;

  Future<void> fetchData(DatabaseHelper db) async {
    _lecturers = await _lecturerService.getAllLecturers(db);
    _starredLecturers =
        await _starredLecturerService.getAllStarredLecturers(db);
  }

  Future<void> addStarredLecturer(DatabaseHelper db, Lecturer lecturer) async {
    await _starredLecturerService.insertStarredLecturer(db, lecturer);
    _lecturers.add(lecturer);
    notifyListeners();
  }

  Future<void> removeStarredLecturer(
      DatabaseHelper db, Lecturer lecturer) async {
    await _starredLecturerService.deleteStarredLecturer(db, lecturer);
    _lecturers.remove(lecturer);
    notifyListeners();
  }
}
