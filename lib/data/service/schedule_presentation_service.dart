import 'package:bsuir_schedule/data/shared_preferences/schedule_presentation_shared_prefs.dart';
import 'package:bsuir_schedule/domain/model/schedule_descriptor.dart';

class SchedulePresentationService {
  static final SchedulePresentationSharedPrefs
      _schedulePresentationSharedPrefs = SchedulePresentationSharedPrefs();

  Future<ScheduleViewType?> getScheduleViewType() async {
    return await _schedulePresentationSharedPrefs.getScheduleViewType();
  }

  Future<void> setScheduleViewType(ScheduleViewType scheduleViewType) async {
    await _schedulePresentationSharedPrefs
        .setScheduleViewType(scheduleViewType);
  }

  Future<ScheduleGroupType?> getScheduleGroupType() async {
    return await _schedulePresentationSharedPrefs.getScheduleGroupType();
  }

  Future<void> setScheduleGroupType(ScheduleGroupType scheduleGroupType) async {
    await _schedulePresentationSharedPrefs
        .setScheduleGroupType(scheduleGroupType);
  }
}
