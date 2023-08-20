import 'package:bsuir_schedule/data/api/group_api.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/group_db.dart';
import 'package:bsuir_schedule/domain/model/group.dart';

class GroupService {
  static final GroupDb _groupDb = GroupDb();
  static final GroupApi _groupApi = GroupApi();

  Future<List<Group>> getAllGroups(DatabaseHelper db) async {
    List<Group> groups = await _groupDb.getAllGroups(db);

    if (groups.isEmpty) {
      groups = await _groupApi.getAllGroups() ?? [];
      await Future.wait(groups.map((e) => _groupDb.insertGroup(db, e)));
    }

    return groups;
  }

  Future<Group?> getGroupById(DatabaseHelper db, int id) async {
    return await _groupDb.getGroupById(db, id);
  }

  Future<Group?> getGroupByName(DatabaseHelper db, String name) async {
    return await _groupDb.getGroupByName(db, name);
  }
}
