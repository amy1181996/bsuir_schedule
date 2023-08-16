import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/service/lecturer_service.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:flutter/foundation.dart';

class LecturerScreenViewModel extends ChangeNotifier {
  List<Lecturer> _lecturers = [];
  static final LecturerService _lecturerService = LecturerService();

  List<Lecturer> get lecturers => _lecturers;

  Future<void> fetchData(DatabaseHelper db) async {
    _lecturers = await _lecturerService.getAllLecturers(db);
  }
}
