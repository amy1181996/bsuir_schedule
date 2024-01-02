import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/service/current_week_service.dart';
import 'package:bsuir_schedule/data/service/group_schedule_service.dart';
import 'package:bsuir_schedule/data/service/group_service.dart';
import 'package:bsuir_schedule/data/service/lecturer_schedule_service.dart';
import 'package:bsuir_schedule/data/service/lecturer_service.dart';
import 'package:bsuir_schedule/data/service/schedule_presentation_service.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:bsuir_schedule/domain/model/schedule_descriptor.dart';
import 'package:bsuir_schedule/domain/model/schedule_factory.dart';
import 'package:bsuir_schedule/ui/screens/view_constants.dart';
import 'package:flutter/foundation.dart';

// TODO: refactor this shit code

// этот класс должен отвечать за доставку расписания до класса ScheduleScreen
// значит, он должен уметь получать данные от сервиса и затем отдавать их классу
// так как расписание может быть в разном виде, то класс будет возвращать ScheduleFactory
// который в свою очередь будет возвращать расписание в нужном виде
class ScheduleScreenViewModel extends ChangeNotifier {
  static final GroupScheduleService _groupScheduleService =
      GroupScheduleService();
  static final LecturerScheduleService _lecturerScheduleService =
      LecturerScheduleService();
  static final GroupService _groupService = GroupService();
  static final LecturerService _lecturerService = LecturerService();
  static final SchedulePresentationService _schedulePresentationService =
      SchedulePresentationService();

  ScheduleGroupType? _scheduleGroupType;
  ScheduleViewType? _scheduleViewType;

  ScheduleGroupType get scheduleGroupType =>
      _scheduleGroupType ?? ScheduleGroupType.allGroup;

  ScheduleViewType get scheduleViewType =>
      _scheduleViewType ?? ScheduleViewType.dayly;

  Future<void> init(DatabaseHelper db) async {
    _scheduleGroupType ??=
        await _schedulePresentationService.getScheduleGroupType();
    _scheduleViewType ??=
        await _schedulePresentationService.getScheduleViewType();
  }

  Future<ScheduleFactory> getSchedule({
    required DatabaseHelper db,
    required ScheduleDescriptor scheduleDescriptor,
  }) async {
    var scheduleFactory = ScheduleFactory.empty();

    switch (scheduleDescriptor.scheduleEntityType) {
      case ScheduleEntityType.group:
        scheduleFactory =
            await getGroupSchedule(db, scheduleDescriptor.entityId);
        break;
      case ScheduleEntityType.lecturer:
        scheduleFactory =
            await getLecturerScheduler(db, scheduleDescriptor.entityId);
        break;
    }

    return scheduleFactory;
  }

  Future<ScheduleFactory> getGroupSchedule(
    DatabaseHelper db,
    int groupId,
  ) async {
    final group = await _groupService.getGroupById(db, groupId);

    if (group == null) {
      return ScheduleFactory.empty();
    }

    final schedule = await _groupScheduleService.getGroupSchedule(db, group);

    if (schedule == null) {
      return ScheduleFactory.empty();
    }

    return ScheduleFactory(schedule: schedule);
  }

  Future<ScheduleFactory> getLecturerScheduler(
    DatabaseHelper db,
    int lecturerId,
  ) async {
    final lecturer = await _lecturerService.getLecturerById(db, lecturerId);

    if (lecturer == null) {
      return ScheduleFactory.empty();
    }

    final schedule =
        await _lecturerScheduleService.getLecturerSchedule(db, lecturer);

    if (schedule == null) {
      return ScheduleFactory.empty();
    }

    return ScheduleFactory(schedule: schedule);
  }

  Future<void> setScheduleGroupType(ScheduleGroupType scheduleGroupType) async {
    _scheduleGroupType = scheduleGroupType;
    await _schedulePresentationService.setScheduleGroupType(scheduleGroupType);
    notifyListeners();
  }

  Future<void> setScheduleViewType(ScheduleViewType scheduleViewType) async {
    _scheduleViewType = scheduleViewType;
    await _schedulePresentationService.setScheduleViewType(scheduleViewType);
    notifyListeners();
  }

  Future<bool> isLecturerScheduleActual(
      DatabaseHelper db, int lecturerId) async {
    final lecturer = await _lecturerService.getLecturerById(db, lecturerId);

    if (lecturer == null) {
      return false;
    }

    return await _lecturerScheduleService.isLecturerScheduleActual(
        db, lecturer);
  }

  Future<bool> isGroupScheduleActual(DatabaseHelper db, int groupId) async {
    final group = await _groupService.getGroupById(db, groupId);

    if (group == null) {
      return false;
    }

    return await _groupScheduleService.isGroupScheduleActual(db, group);
  }
}
