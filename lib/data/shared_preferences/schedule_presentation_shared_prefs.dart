import 'package:bsuir_schedule/domain/model/schedule_descriptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulePresentationSharedPrefs {
  Future<ScheduleViewType?> getScheduleViewType() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleViewType = prefs.getString('scheduleViewType');

    if (scheduleViewType == null) {
      return null;
    }

    return ScheduleViewType.values
        .firstWhere((element) => element.toString() == scheduleViewType);
  }

  Future<void> setScheduleViewType(ScheduleViewType scheduleViewType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('scheduleViewType', scheduleViewType.toString());
  }

  Future<ScheduleGroupType?> getScheduleGroupType() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleGroupType = prefs.getString('scheduleGroupType');

    if (scheduleGroupType == null) {
      return null;
    }

    return ScheduleGroupType.values
        .firstWhere((element) => element.toString() == scheduleGroupType);
  }

  Future<void> setScheduleGroupType(ScheduleGroupType scheduleGroupType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('scheduleGroupType', scheduleGroupType.toString());
  }
}
