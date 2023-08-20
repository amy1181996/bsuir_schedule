import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/service/image_service.dart';
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
  static final ImageService _imageService = ImageService();
  static final TextEditingController _searchController =
      TextEditingController();
  static final LecturerScheduleService _lecturerScheduleService =
      LecturerScheduleService();

  List<Lecturer> get lecturers => _shownLecturers;
  List<Lecturer> get starredLecturers => _shownStarredLecturers;

  TextEditingController get searchController => _searchController;

  LecturerScreenViewModel() {
    _searchController.addListener(_search);
  }

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
      notifyListeners();
    }
  }

  Future<Uint8List?> getLecturerPhoto(String photoPath) async {
    return await _imageService.getLecturerPhoto(photoPath);
  }

  void _search() {
    final String query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      _shownLecturers = _lecturers;
      _shownStarredLecturers = _starredLecturers;
    } else {
      _shownLecturers = _lecturers
          .where((lecturer) =>
              lecturer.firstName.toLowerCase().contains(query) ||
              lecturer.lastName.toLowerCase().contains(query) ||
              lecturer.middleName.toLowerCase().contains(query))
          .toList();
      _shownStarredLecturers = [];
    }

    notifyListeners();
  }
}
