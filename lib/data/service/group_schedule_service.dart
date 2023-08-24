import 'package:bsuir_schedule/data/api/group_schedule_api.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/group_schedule_db.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/model/schedule.dart';
import 'package:sqflite/sqflite.dart';

class GroupScheduleService {
  static final GroupScheduleApi _groupScheduleApi = GroupScheduleApi();
  static final GroupScheduleDb _groupScheduleDb = GroupScheduleDb();

  Future<Schedule?> getGroupSchedule(DatabaseHelper db, Group group) async {
    Schedule? schedule = await _groupScheduleDb.getGroupSchedule(db, group);

    if (schedule == null || schedule.schedules.isEmpty) {
      schedule = await _groupScheduleApi.getGroupSchedule(db, group);

      if (schedule != null) {
        try {
          await _groupScheduleDb.insertGroupSchedule(db, schedule);
        } on DatabaseException catch (e) {
          if (e.isUniqueConstraintError()) {
            await _groupScheduleDb.updateGroupSchedule(db, schedule);
          } else {
            rethrow;
          }
        }
      }
    }

    return schedule;
  }

  Future<int> removeGroupSchedule(DatabaseHelper db, Group group) async {
    Schedule? schedule = await _groupScheduleDb.getGroupSchedule(db, group);
    return schedule != null
        ? await _groupScheduleDb.removeGroupSchedule(db, schedule)
        : 0;
  }

  Future<int> updateGroupSchedule(DatabaseHelper db, Group group) async {
    Schedule? schedule = await _groupScheduleApi.getGroupSchedule(db, group);

    if (schedule != null) {
      return await _groupScheduleDb.updateGroupSchedule(db, schedule);
    } else {
      return 0;
    }
  }
}
