import 'package:bsuir_schedule/view/view_constants.dart';
import 'package:flutter/material.dart';

class ScheduleTabWidget extends StatelessWidget {
  final ScheduleViewType scheduleType;
  final DateTime? date;

  const ScheduleTabWidget({
    super.key,
    required this.scheduleType,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final double height, width;

    switch (scheduleType) {
      case ScheduleViewType.daylyAllGroup:
      case ScheduleViewType.daylyFirstSubgroup:
      case ScheduleViewType.daylySecondSubgroup:
        height = 60;
        width = 25;
        break;
      case ScheduleViewType.fullAllGroup:
      case ScheduleViewType.fullFirstSubgroup:
      case ScheduleViewType.fullSecondSubgroup:
        height = 30;
        width = 95;
        break;
      case ScheduleViewType.exams:
        height = 30;
        width = 400;
        break;
    }

    return Tab(
      height: height,
      child: SizedBox(
        width: width,
        child: getChild(context),
      ),
    );
  }

  Widget getChild(BuildContext context) {
    switch (scheduleType) {
      case ScheduleViewType.daylyAllGroup:
      case ScheduleViewType.daylyFirstSubgroup:
      case ScheduleViewType.daylySecondSubgroup:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ScheduleWidgetConstants.weekdayAbbrevList[date!.weekday - 1],
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              '${date!.day}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${date!.month}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        );
      case ScheduleViewType.fullAllGroup:
      case ScheduleViewType.fullFirstSubgroup:
      case ScheduleViewType.fullSecondSubgroup:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ScheduleWidgetConstants.weekdayAbbrevList[date!.weekday - 1],
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        );
      case ScheduleViewType.exams:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ЭКЗАМЕНЫ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        );
    }
  }
}
