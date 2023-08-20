import 'package:bsuir_schedule/data/api/lecturer_schedule_api.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/lecturer_schedule_db.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/schedule.dart';

class LecturerScheduleService {
  static final LecturerScheduleDb _lecturerScheduleDb = LecturerScheduleDb();
  static final LecturerScheduleApi _lecturerScheduleApi = LecturerScheduleApi();

  Future<Schedule?> getLecturerSchedule(
      DatabaseHelper db, Lecturer lecturer) async {
    Schedule? schedule =
        await _lecturerScheduleDb.getLecturerSchedule(db, lecturer);

    if (schedule == null) {
      schedule = await _lecturerScheduleApi.getLecturerSchedule(db, lecturer);

      if (schedule != null) {
        await _lecturerScheduleDb.insertLecturerSchedule(db, schedule);
      }
    }

    return schedule;
  }
}
