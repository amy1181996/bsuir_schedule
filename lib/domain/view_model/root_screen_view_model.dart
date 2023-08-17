import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/service/selected_schedule_service.dart';
import 'package:flutter/foundation.dart';

class RootScreenViewModel extends ChangeNotifier {
  int? _selectedGroupId;
  int? _selectedLecturerId;

  static final DatabaseHelper _db = DatabaseHelper();
  static final SelectedScheduleService _selectedScheduleService =
      SelectedScheduleService();

  DatabaseHelper get db => _db;

  Future<bool> init() async {
    await _db.init();
    _selectedGroupId = await _selectedScheduleService.getSelectedGroupId();
    _selectedLecturerId =
        await _selectedScheduleService.getSelectedLecturerId();

    return true;
  }

  int? get selectedGroupId => _selectedGroupId;
  int? get selectedLecturerId => _selectedLecturerId;

  Future<void> setSelectedGroupId(int? id) async {
    _selectedGroupId = id;
    await _selectedScheduleService.setSelectedGroupId(id);
    _selectedLecturerId = null;
    await _selectedScheduleService.setSelectedLecturerId(null);
    notifyListeners();
  }

  Future<void> setSelectedLecturerId(int? id) async {
    _selectedLecturerId = id;
    await _selectedScheduleService.setSelectedLecturerId(id);
    _selectedGroupId = null;
    await _selectedScheduleService.setSelectedGroupId(null);
    notifyListeners();
  }
}
