import 'package:bsuir_schedule/ui/themes/lesson_tab_style.dart';
import 'package:bsuir_schedule/ui/screens/view_constants.dart';
import 'package:flutter/material.dart';

class LessonTab extends StatelessWidget {
  final LessonTabStyle? style;
  final ScheduleViewType scheduleType;
  final DateTime? date;

  const LessonTab({
    super.key,
    this.style,
    required this.scheduleType,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).extension<LessonTabStyle>()!;

    final weekdayStyle = style?.weekdayStyle ?? defaultStyle.weekdayStyle;
    final dateStyle = style?.dateStyle ?? defaultStyle.dateStyle;

    final double height, width;

    switch (scheduleType) {
      case ScheduleViewType.dayly:
        height = 60;
        width = 25;
        break;
      case ScheduleViewType.full:
        height = 30;
        width = 95;
        break;
      case ScheduleViewType.exams:
        height = 30;
        width = 400;
        break;
    }

    return SizedBox(
      height: height,
      width: width,
      child: Tab(
        child: getChild(weekdayStyle, dateStyle),
      ),
    );
  }

  Widget getChild(TextStyle weekdayStyle, TextStyle dateStyle) {
    switch (scheduleType) {
      case ScheduleViewType.dayly:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ScheduleWidgetConstants.weekdayAbbrevList[date!.weekday - 1],
                style: weekdayStyle,
              ),
              Text(
                '${date!.day}',
                style: dateStyle,
              ),
              Text(
                '${date!.month}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      case ScheduleViewType.full:
        return Center(
          child: Text(
            ScheduleWidgetConstants.weekdayAbbrevList[date!.weekday - 1],
            style: dateStyle,
          ),
        );
      case ScheduleViewType.exams:
        return Center(
          child: Text(
            'ЭКЗАМЕНЫ',
            style: dateStyle,
          ),
        );
    }
  }
}
