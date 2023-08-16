import 'package:bsuir_schedule/data/db/db_helper/db_constants.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/model/base_model.dart';
import 'package:bsuir_schedule/data/db/model/group.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:sqflite/sqflite.dart';

class AddStarredGroup extends BaseModel {
  final int groupId;

  AddStarredGroup(this.groupId);

  @override
  Map<String, dynamic> toMap() {
    return {
      'group_id': groupId,
    };
  }
}

class StarredGroupDb {
  Future<List<Group>> getAllStarredGroups(DatabaseHelper db) async {
    final List<Map<String, dynamic>> maps =
        await db.query(DbTableName.starredGroup);
    final List<int> ids = maps.map((map) => map['group_id'] as int).toList();

    final List<Group> groups = [];

    for (var id in ids) {
      final groupData =
          (await db.queryWhere(DbTableName.group, 'id = ?', [id])).firstOrNull;

      if (groupData != null) {
        final group = GetGroup.fromMap(groupData).toGroup();
        groups.add(group);
      }
    }

    return groups;
  }

  Future<int> insertStarredGroup(DatabaseHelper db, Group group) async {
    try {
      return await db.insert(
          DbTableName.starredGroup, AddStarredGroup(group.id));
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        return 0;
      } else {
        rethrow;
      }
    }
  }

  Future<int> deleteStarredGroup(DatabaseHelper db, Group group) async {
    return await db.delete(DbTableName.starredGroup, AddStarredGroup(group.id));
  }
}
