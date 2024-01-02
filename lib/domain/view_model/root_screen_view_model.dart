import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/service/group_service.dart';
import 'package:bsuir_schedule/data/service/lecturer_service.dart';
import 'package:bsuir_schedule/data/service/selected_schedule_service.dart';
import 'package:bsuir_schedule/domain/model/schedule_descriptor.dart';
import 'package:flutter/foundation.dart';

import '../../data/service/group_schedule_service.dart';
import '../../data/service/lecturer_schedule_service.dart';
import '../model/group.dart';
import '../model/lecturer.dart';
import '../model/schedule.dart';

class RootScreenViewModel extends ChangeNotifier {
  static final DatabaseHelper _db = DatabaseHelper();

  static final SelectedScheduleService _selectedScheduleService =
      SelectedScheduleService();

  static final GroupScheduleService _groupScheduleService =
      GroupScheduleService();
  static final GroupService _groupService = GroupService();

  static final LecturerScheduleService _lecturerScheduleService =
      LecturerScheduleService();
  static final LecturerService _lecturerService = LecturerService();

  DatabaseHelper get db => _db;

  ScheduleDescriptor? _currentScheduleDescriptor;
  ScheduleDescriptor? get currentScheduleDescriptor =>
      _currentScheduleDescriptor;

  Future<bool> init() async {
    await _db.init();

    // TODO: подгружаем дескриптор расписания
    return true;
  }

  // returns -1 if could not select schedule,
  // 0 if selected schedule is already selected,
  // or if success it returns id
  Future<int> setSchedule(ScheduleDescriptor? scheduleDescriptor) async {
    if (scheduleDescriptor == null) {
      return 0;
    }

    if (scheduleDescriptor == _currentScheduleDescriptor) {
      return 0;
    }

    Schedule? schedule;
    Group? group;
    Lecturer? lecturer;

    if (scheduleDescriptor.scheduleEntityType == ScheduleEntityType.group) {
      group = await _groupService.getGroupById(
        db, scheduleDescriptor.entityId,
      );

      if (group == null) {
        return -1;
      }

      schedule = await _groupScheduleService.getGroupSchedule(
        db, group,
      );
    } else {
      lecturer = await _lecturerService.getLecturerById(
        db, scheduleDescriptor.entityId,
      );

      if (lecturer == null) {
        return -1;
      }

       schedule = await _lecturerScheduleService.getLecturerSchedule(
        db, lecturer,
      );
    }

    // TODO: вот эта часть кода мне очень не нравицца, т.к. есть и возвращаемое значение, и notifyListeners()
    if (schedule != null) {
      _currentScheduleDescriptor = scheduleDescriptor;
      notifyListeners();

      if (scheduleDescriptor.scheduleEntityType == ScheduleEntityType.group) {
        await _selectedScheduleService.setSelectedGroupId(group!.id);
      } else {
        await _selectedScheduleService.setSelectedLecturerId(lecturer!.id);
      }

      return schedule.id;
    } else {
      return -1;
    }
  }
}
