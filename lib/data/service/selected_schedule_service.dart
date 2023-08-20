import 'package:bsuir_schedule/data/shared_preferences/selected_schedule_shared_prefs.dart';

class SelectedScheduleService {
  static final SelectedScheduleSharedPreferences
      _selectedScheduleSharedPreferences = SelectedScheduleSharedPreferences();

  Future<int?> getSelectedGroupId() async {
    return await _selectedScheduleSharedPreferences.getSelectedGroupId();
  }

  Future<void> setSelectedGroupId(int? id) async {
    await _selectedScheduleSharedPreferences.setSelectedGroupId(id);
  }

  Future<int?> getSelectedLecturerId() async {
    return await _selectedScheduleSharedPreferences.getSelectedLecturerId();
  }

  Future<void> setSelectedLecturerId(int? id) async {
    await _selectedScheduleSharedPreferences.setSelectedLecturerId(id);
  }
}
