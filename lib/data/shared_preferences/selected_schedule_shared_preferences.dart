import 'package:shared_preferences/shared_preferences.dart';

class SelectedScheduleSharedPreferences {
  Future<int?> getSelectedGroupId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('selected_group_id');
    return id == -1 ? null : id;
  }

  Future<void> setSelectedGroupId(int? id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_group_id', id ?? -1);
  }

  Future<int?> getSelectedLecturerId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('selected_lecturer_id');
    return id == -1 ? null : id;
  }

  Future<void> setSelectedLecturerId(int? id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_lecturer_id', id ?? -1);
  }
}
