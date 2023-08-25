import 'package:bsuir_schedule/data/db/db_helper/db_constants.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/model/last_update.dart';
import 'package:bsuir_schedule/domain/model/schedule.dart';
import 'package:sqflite/sqflite.dart';

class ScheduleLastUpdateDb {
  Future<DateTime?> getLastUpdate(DatabaseHelper db, Schedule schedule) async {
    final maps = (await db.queryWhere(
            DbTableName.scheduleLastUpdate, 'schedule_id = ?', [schedule.id]))
        .firstOrNull;

    if (maps == null) {
      return null;
    }

    final getLastUpdate = GetLastUpdate.fromMap(maps);

    return getLastUpdate.lastUpdate;
  }

  Future<int> insertLastUpdate(
      DatabaseHelper db, Schedule schedule, DateTime lastUpdate) async {
    try {
      final a = await db.insert(
        DbTableName.scheduleLastUpdate,
        AddLastUpdate(
          scheduleId: schedule.id,
          lastUpdate: lastUpdate,
        ),
      );
      return a;
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        return -1;
      } else {
        rethrow;
      }
    }
  }

  Future<int> updateLastUpdate(
      DatabaseHelper db, Schedule schedule, DateTime lastUpdate) async {
    return await db.updateWhere(
      DbTableName.scheduleLastUpdate,
      AddLastUpdate(
        scheduleId: schedule.id,
        lastUpdate: lastUpdate,
      ),
      'schedule_id = ?',
      [schedule.id],
    );
  }
}
