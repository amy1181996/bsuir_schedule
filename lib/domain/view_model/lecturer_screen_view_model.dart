import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/service/lecturer_schedule_service.dart';
import 'package:bsuir_schedule/data/service/lecturer_service.dart';
import 'package:bsuir_schedule/data/service/starred_lecturer_service.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LecturerScreenViewModel extends ChangeNotifier {
  List<Lecturer> _lecturers = [];
  List<Lecturer> _shownLecturers = [];
  List<Lecturer> _starredLecturers = [];
  List<Lecturer> _shownStarredLecturers = [];
  static final LecturerService _lecturerService = LecturerService();
  static final StarredLecturerService _starredLecturerService =
      StarredLecturerService();
  static final LecturerScheduleService _lecturerScheduleService =
      LecturerScheduleService();

  List<Lecturer> get lecturers => _shownLecturers;
  List<Lecturer> get starredLecturers => _shownStarredLecturers;

  Future<bool> fetchData(DatabaseHelper db) async {
    _lecturers = await _lecturerService.getAllLecturers(db);
    _starredLecturers =
        await _starredLecturerService.getAllStarredLecturers(db);
    _shownLecturers = _lecturers;
    _shownStarredLecturers = _starredLecturers;
    return true;
  }

  Future<void> addStarredLecturer(DatabaseHelper db, Lecturer lecturer) async {
    final int inserted =
        await _starredLecturerService.insertStarredLecturer(db, lecturer);

    if (inserted != -1) {
      _starredLecturers.add(lecturer);
      await _lecturerScheduleService.getLecturerSchedule(db, lecturer);
      notifyListeners();
    }
  }

  Future<void> removeStarredLecturer(
      DatabaseHelper db, Lecturer lecturer) async {
    final int deleted =
        await _starredLecturerService.deleteStarredLecturer(db, lecturer);

    if (deleted != 0) {
      _starredLecturers.remove(lecturer);
      await _lecturerScheduleService.removeLecturerSchedule(db, lecturer);
      notifyListeners();
    }
  }

  Future<void> updateStarredLecturer(
      DatabaseHelper db, Lecturer lecturer) async {
    await _lecturerScheduleService.updateLecturerSchedule(db, lecturer);
  }

  Future<void> updateLecturers(DatabaseHelper db) async {
    await _lecturerService.updateLecturers(db);
    _lecturers = await _lecturerService.getAllLecturers(db);
    _shownLecturers = _lecturers;
    notifyListeners();
  }
}
