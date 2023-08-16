import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/service/group_service.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:flutter/foundation.dart';

class GroupScreenViewModel extends ChangeNotifier {
  List<Group> _groups = [];
  static final GroupService _groupService = GroupService();

  List<Group> get groups => _groups;

  Future<void> fetchData(DatabaseHelper db) async {
    _groups = await _groupService.getAllGroups(db);
  }
}
