import 'dart:async';

import 'package:bsuir_schedule/domain/view_model/schedule_screen_view_model.dart';
import 'package:bsuir_schedule/ui/themes/lesson_time_bar_style.dart';
import 'package:flutter/material.dart';

import '../../domain/model/schedule_factory.dart';

class LessonTimeBar extends StatefulWidget {
  final LessonTimeBarStyle? style;
  final DaySchedule? daySchedule;

  const LessonTimeBar({
    super.key,
    this.style,
    required this.daySchedule,
  });

  @override
  State<LessonTimeBar> createState() => _LessonTimeBarState();
}

class _LessonTimeBarState extends State<LessonTimeBar> {
  final ValueNotifier<DateTime> _dateTime =
      ValueNotifier<DateTime>(DateTime.now());

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 15), (_) {
      _dateTime.value = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.daySchedule == null ? _timeBar('Сегодня пар нет') : getTimeWidget(widget.daySchedule!);
  }

  DateTime toDateTime(String time) {
    final now = DateTime.now();
    final hour = int.parse(time.split(':')[0]);
    final minute = int.parse(time.split(':')[1]);

    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  String _getMinutes(int minutes) => switch (minutes % 10) {
        1 => minutes == 11 ? 'минут' : 'минута',
        2 => minutes == 12 ? 'минут' : 'минуты',
        3 => minutes == 13 ? 'минут' : 'минуты',
        4 => minutes == 14 ? 'минут' : 'минуты',
        _ => 'минут',
      };

  Widget getTimeWidget(DaySchedule currentSchedule) =>
      ValueListenableBuilder<DateTime>(
        valueListenable: _dateTime,
        builder: (context, now, child) {
          final lesson = currentSchedule.lessons.firstOrNull;

          String titleString = '';

          if (lesson == null) {
            titleString = 'Сегодня пар нет';
            return _timeBar(titleString);
          }

          final startTime = toDateTime(lesson.startLessonTime);
          final endTime =
              toDateTime(currentSchedule.lessons.last.endLessonTime);

          debugPrint(now.toString());

          if (now.isBefore(startTime)) {
            titleString =
                'Пары начнутся в ${currentSchedule.lessons.first.startLessonTime}';
            return _timeBar(titleString);
          } else if (now.isAfter(endTime)) {
            titleString = 'Пары закончились';
            return _timeBar(titleString);
          } else {
            for (var lesson in currentSchedule.lessons) {
              final startLessonTime = toDateTime(lesson.startLessonTime);
              final endLessonTime = toDateTime(lesson.endLessonTime);

              if (now == startLessonTime ||
                  now.isAfter(startLessonTime) && now.isBefore(endLessonTime)) {
                final difference = endLessonTime.difference(now).inMinutes;
                titleString =
                    'До конца пары осталось $difference ${_getMinutes(difference)}';
                break;
              } else if (now == endLessonTime ||
                  now.isBefore(startLessonTime)) {
                final difference = startLessonTime.difference(now).inMinutes;
                titleString =
                    'До начала пары осталось $difference ${_getMinutes(difference)}';
                break;
              }
            }

            return _timeBar(titleString);
          }
        },
      );

  Widget _timeBar(String titleString) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.style?.backgroundColor ??
              Theme.of(context).extension<LessonTimeBarStyle>()!.backgroundColor,
        ),
        child: Text(
          titleString,
          style: widget.style?.textStyle ??
              Theme.of(context).extension<LessonTimeBarStyle>()!.textStyle,
        ),
      );
}
