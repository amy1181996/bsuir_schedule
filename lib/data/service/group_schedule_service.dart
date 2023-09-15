import 'package:bsuir_schedule/data/api/group_schedule_api.dart';
import 'package:bsuir_schedule/data/api/group_schedule_last_update_api.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/group_schedule_db.dart';
import 'package:bsuir_schedule/data/db/schedule_last_update_db.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/model/schedule.dart';

class GroupScheduleService {
  static final GroupScheduleApi _groupScheduleApi = GroupScheduleApi();
  static final GroupScheduleDb _groupScheduleDb = GroupScheduleDb();
  static final ScheduleLastUpdateDb _scheduleLastUpdateDb =
      ScheduleLastUpdateDb();
  static final GroupScheduleLastUpdateApi _groupScheduleLastUpdateApi =
      GroupScheduleLastUpdateApi();

  Future<Schedule?> getGroupSchedule(DatabaseHelper db, Group group) async {
    Schedule? schedule = await _groupScheduleDb.getGroupSchedule(db, group);

    if (schedule == null) {
      schedule = await _groupScheduleApi.getGroupSchedule(db, group);

      if (schedule != null) {
        final int scheduleId =
            await _groupScheduleDb.insertGroupSchedule(db, schedule);
        schedule = schedule.copyWith(id: scheduleId);
        await _scheduleLastUpdateDb.insertLastUpdate(
            db, schedule, DateTime.now());
      }

      return schedule;
    }

    // final lastUpdate = await _scheduleLastUpdateDb.getLastUpdate(db, schedule);
    // final actualLastUpdate =
    //     await _groupScheduleLastUpdateApi.getGroupScheduleLastUpdate(group);

    // if (lastUpdate == null ||
    //     schedule.schedules.isEmpty ||
    //     actualLastUpdate == null ||
    //     lastUpdate.isBefore(actualLastUpdate)) {
    //   final apiSchedule = await _groupScheduleApi.getGroupSchedule(db, group);

    //   if (apiSchedule != null) {
    //     schedule = apiSchedule.copyWith(id: schedule.id);
    //     await _groupScheduleDb.updateGroupSchedule(db, schedule);
    //     await _scheduleLastUpdateDb.insertLastUpdate(
    //         db, schedule, DateTime.now());
    //   }

    //   return schedule;
    // }

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
      final int update =
          await _groupScheduleDb.updateGroupSchedule(db, schedule);
      await _scheduleLastUpdateDb.insertLastUpdate(
          db, schedule, DateTime.now());
      return update;
    } else {
      return -1;
    }
  }

  Future<bool> isGroupScheduleActual(DatabaseHelper db, Group group) async {
    final schedule = await _groupScheduleDb.getGroupSchedule(db, group);

    if (schedule == null) {
      return false;
    }

    final lastUpdate = await _scheduleLastUpdateDb.getLastUpdate(db, schedule);

    if (lastUpdate == null) {
      return false;
    }

    final actualLastUpdate =
        await _groupScheduleLastUpdateApi.getGroupScheduleLastUpdate(group);

    if (actualLastUpdate == null) {
      return false;
    }

    return lastUpdate.isAfter(actualLastUpdate);
  }
}
