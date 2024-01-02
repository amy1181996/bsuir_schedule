import 'package:bsuir_schedule/data/service/current_week_service.dart';
import 'package:bsuir_schedule/domain/model/schedule.dart';
import 'package:bsuir_schedule/domain/model/schedule_descriptor.dart';

import 'lesson.dart';

// у расписания на день может быть несколько состояний?:
// занятия не начались, занятия закончились, выходной день, будний день

class ScheduleFactory {
  static final CurrentWeekService _currentWeekService = CurrentWeekService();

  Map<ScheduleGroupType, List<DaySchedule>>? _daylySchedules;
  Map<ScheduleGroupType, List<DaySchedule>>? _fullSchedules;

  int? _currentWeek;
  late DateTime _currentDate;
  DateTime? _startDate;
  DateTime? _endDate;

  Schedule? schedule;

  DateTime? get currentDate => _currentDate;

  int? get currentWeek => _currentWeek;

  DateTime? get startDate => _startDate;

  DateTime? get endDate => _endDate;

  ScheduleFactory({
    required this.schedule,
  }) {
    _currentDate = DateTime.now();
    _currentWeek = _currentWeekService.getCurrentWeek();

    if (schedule != null) {
      _startDate = schedule!.startDate;
      _endDate = schedule!.endDate;
    }

    makeSchedule();
  }

  factory ScheduleFactory.empty() {
    return ScheduleFactory(schedule: null);
  }

  List<DaySchedule> getSchedule({
    required ScheduleViewType scheduleViewType,
    ScheduleGroupType scheduleGroupType = ScheduleGroupType.allGroup,
    DateTime? date,
  }) {
    if (schedule == null) {
      return [];
    }

    if (date != null && date != _currentDate) {
      _currentDate = date;
      _currentWeek = _currentWeekService.getWeekNumberFor(date);
      makeSchedule();
    }

    switch (scheduleViewType) {
      case ScheduleViewType.dayly:
        {
          return _daylySchedules?[scheduleGroupType] ?? [];
        }
      case ScheduleViewType.full:
        {
          return _fullSchedules?[scheduleGroupType] ?? [];
        }
      case ScheduleViewType.exams:
        {
          return [DaySchedule(DateTime.now(), schedule!.exams)];
        }
      case ScheduleViewType.announcements:
        {
          return [DaySchedule(DateTime.now(), schedule!.announcements)];
        }
    }
  }

  void makeSchedule() {
    if (schedule == null) {
      return;
    }

    int daysUntilMonday = (8 - _currentDate.weekday) % 7;
    final now = _currentDate.add(Duration(days: daysUntilMonday));

    _fullSchedules = {
      ScheduleGroupType.allGroup: [],
      ScheduleGroupType.firstSubgroup: [],
      ScheduleGroupType.secondSubgroup: [],
    };

    for (var entry in schedule!.schedules.entries) {
      _fullSchedules![ScheduleGroupType.allGroup]!.add(DaySchedule(
        now.add(Duration(days: entry.key)),
        // null,
        entry.value,
      ));

      _fullSchedules![ScheduleGroupType.firstSubgroup]!.add(DaySchedule(
        now.add(Duration(days: entry.key)),
        // null,
        entry.value.where((lesson) => lesson.numSubgroup != 2).toList(),
      ));

      _fullSchedules![ScheduleGroupType.secondSubgroup]!.add(DaySchedule(
        now.add(Duration(days: entry.key)),
        // null,
        entry.value.where((lesson) => lesson.numSubgroup != 1).toList(),
      ));
    }

    _daylySchedules = {
      ScheduleGroupType.allGroup: [],
      ScheduleGroupType.firstSubgroup: [],
      ScheduleGroupType.secondSubgroup: [],
    };

    int currentWeek = _currentWeek!;

    for (int i = 0; i < 14; i++) {
      final currentDate = _currentDate.add(Duration(days: i));

      if (currentDate.compareTo(_startDate!) >= 0 &&
          currentDate.compareTo(_endDate!) <= 0) {
        var schedules = schedule!.schedules[currentDate.weekday - 1]
                ?.where((element) => element.weeks.contains(currentWeek))
                .toList() ??
            [];
        schedules = schedules
            .where((element) =>
                element.dateLesson == null ||
                element.dateLesson!.compareTo(currentDate) == 0)
            .toList();

        _daylySchedules![ScheduleGroupType.allGroup]!.add(DaySchedule(
          currentDate,
          schedules,
        ));

        _daylySchedules![ScheduleGroupType.firstSubgroup]!.add(DaySchedule(
          currentDate,
          schedules.where((lesson) => lesson.numSubgroup != 2).toList(),
        ));

        _daylySchedules![ScheduleGroupType.secondSubgroup]!.add(DaySchedule(
          currentDate,
          schedules.where((lesson) => lesson.numSubgroup != 1).toList(),
        ));
      }

      currentWeek = _currentWeekService.getWeekNumberFor(currentDate);
      daysUntilMonday = (8 - currentDate.weekday) % 7;
    }
  }

  String getScheduleName() {
    if (schedule == null) {
      return '';
    } else {
      if (schedule!.group != null) {
        return schedule!.group!.name;
      } else {
        return '${schedule!.lecturer!.firstName} ${schedule!.lecturer!.lastName} ${schedule!.lecturer!.middleName}';
      }
    }
  }
}

class DaySchedule {
  final DateTime? date;
  final List<Lesson> lessons;

  DaySchedule(this.date, this.lessons);
}
