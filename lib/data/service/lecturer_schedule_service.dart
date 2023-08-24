import 'package:bsuir_schedule/data/api/lecturer_schedule_api.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/lecturer_schedule_db.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/schedule.dart';
import 'package:sqflite/sqflite.dart';

class LecturerScheduleService {
  static final LecturerScheduleDb _lecturerScheduleDb = LecturerScheduleDb();
  static final LecturerScheduleApi _lecturerScheduleApi = LecturerScheduleApi();

  Future<Schedule?> getLecturerSchedule(
      DatabaseHelper db, Lecturer lecturer) async {
    Schedule? schedule =
        await _lecturerScheduleDb.getLecturerSchedule(db, lecturer);

    if (schedule == null || schedule.schedules.isEmpty) {
      schedule = await _lecturerScheduleApi.getLecturerSchedule(db, lecturer);

      if (schedule != null) {
        try {
          await _lecturerScheduleDb.insertLecturerSchedule(db, schedule);
        } on DatabaseException catch (e) {
          if (e.isUniqueConstraintError()) {
            await _lecturerScheduleDb.updateLecturerSchedule(db, schedule);
          } else {
            rethrow;
          }
        }
      }
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
}
