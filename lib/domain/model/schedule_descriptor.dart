import 'package:bsuir_schedule/ui/screens/view_constants.dart';

enum ScheduleEntityType {
  group,
  lecturer,
}

enum ScheduleViewType {
  full,
  dayly,
  exams,
  announcements,
}

enum ScheduleGroupType {
  allGroup,
  firstSubgroup,
  secondSubgroup,
}

class ScheduleDescriptor {
  final ScheduleEntityType scheduleEntityType;
  final ScheduleViewType scheduleViewType;
  final ScheduleGroupType scheduleGroupType;
  final int entityId;

  ScheduleDescriptor({
    required this.scheduleEntityType,
    required this.scheduleViewType,
    required this.scheduleGroupType,
    required this.entityId,
  });

  ScheduleDescriptor copyWith({
    ScheduleEntityType? scheduleEntityType,
    ScheduleViewType? scheduleViewType,
    ScheduleGroupType? scheduleGroupType,
    int? entityId,
  }) =>
      ScheduleDescriptor(
        scheduleEntityType: scheduleEntityType ?? this.scheduleEntityType,
        scheduleViewType: scheduleViewType ?? this.scheduleViewType,
        scheduleGroupType: scheduleGroupType ?? this.scheduleGroupType,
        entityId: entityId ?? this.entityId,
      );
}
