import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/service/image_service.dart';
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
  static final ImageService _imageService = ImageService();

  List<Lecturer> get lecturers => _lecturers;
  List<Lecturer> get starredLecturers => _starredLecturers;

  Future<bool> fetchData(DatabaseHelper db) async {
    _lecturers = await _lecturerService.getAllLecturers(db);
    _starredLecturers =
        await _starredLecturerService.getAllStarredLecturers(db);
    return true;
  }

  Future<void> addStarredLecturer(DatabaseHelper db, Lecturer lecturer) async {
    final int inserted =
        await _starredLecturerService.insertStarredLecturer(db, lecturer);

    if (inserted != 0) {
      _starredLecturers.add(lecturer);
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
}
