import 'package:bsuir_schedule/data/api/group_schedule_api.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/group_schedule_db.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/model/schedule.dart';

class GroupScheduleService {
  static final GroupScheduleApi _groupScheduleApi = GroupScheduleApi();
  static final GroupScheduleDb _groupScheduleDb = GroupScheduleDb();

  Future<Schedule?> getGroupSchedule(DatabaseHelper db, Group group) async {
    Schedule? schedule = await _groupScheduleDb.getGroupSchedule(db, group);

    if (schedule == null) {
      schedule = await _groupScheduleApi.getGroupSchedule(db, group);

      if (schedule != null) {
        await _groupScheduleDb.insertGroupSchedule(db, schedule);
      }
    }

    return schedule;
  }
}
