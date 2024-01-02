import 'package:bsuir_schedule/data/api/lecturer_schedule_api.dart';
import 'package:bsuir_schedule/data/api/lecturer_schedule_last_update_api.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/lecturer_schedule_db.dart';
import 'package:bsuir_schedule/data/db/schedule_last_update_db.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/schedule.dart';

class LecturerScheduleService {
  static final LecturerScheduleDb _lecturerScheduleDb = LecturerScheduleDb();
  static final LecturerScheduleApi _lecturerScheduleApi = LecturerScheduleApi();
  static final ScheduleLastUpdateDb _scheduleLastUpdateDb =
      ScheduleLastUpdateDb();
  static final LecturerScheduleLastUpdateApi _lecturerScheduleLastUpdateApi =
      LecturerScheduleLastUpdateApi();

  Future<Schedule?> getLecturerSchedule(
    DatabaseHelper db,
    Lecturer lecturer,
  ) async {
    Schedule? schedule =
        await _lecturerScheduleDb.getLecturerSchedule(db, lecturer);

    if (schedule == null) {
      schedule = await _lecturerScheduleApi.getLecturerSchedule(db, lecturer);

      if (schedule != null) {
        final int scheduleId =
            await _lecturerScheduleDb.insertLecturerSchedule(db, schedule);
        schedule = schedule.copyWith(id: scheduleId);
        await _scheduleLastUpdateDb.insertLastUpdate(
            db, schedule, DateTime.now());
      }

      return schedule;
    }

    return schedule;
  }

  Future<int> removeLecturerSchedule(
      DatabaseHelper db, Lecturer lecturer) async {
    Schedule? schedule =
        await _lecturerScheduleDb.getLecturerSchedule(db, lecturer);

    return schedule != null
        ? await _lecturerScheduleDb.deleteLecturerSchedule(db, schedule)
        : 0;
  }

  Future<int> updateLecturerSchedule(
      DatabaseHelper db, Lecturer lecturer) async {
    Schedule? schedule =
        await _lecturerScheduleApi.getLecturerSchedule(db, lecturer);

    if (schedule != null) {
      return await _lecturerScheduleDb.updateLecturerSchedule(db, schedule);
    } else {
      return 0;
    }
  }

  Future<bool> isLecturerScheduleActual(
      DatabaseHelper db, Lecturer lecturer) async {
    final schedule =
        await _lecturerScheduleDb.getLecturerSchedule(db, lecturer);

    if (schedule == null) {
      return false;
    }

    final lastUpdate = await _scheduleLastUpdateDb.getLastUpdate(db, schedule);

    if (lastUpdate == null) {
      return false;
    }

    final actualLastUpdate =
        await _lecturerScheduleLastUpdateApi.getLecturerLastUpdate(lecturer);

    if (actualLastUpdate == null) {
      return false;
    }

    return lastUpdate.isAfter(actualLastUpdate);
  }
}
